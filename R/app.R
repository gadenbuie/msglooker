#' Run Outlook Message Looker App
#'
#' Runs a Shiny app or gadget to read an Outlook message by dragging the `.msg`
#' file into the window. The `.msg` file is converted to a self-contained
#' HTML document (including attachments) using the \pkg{msgxtractor} and
#' \pkg{base64enc} packages. You can also download the self-contained HTML file.
#'
#' @param ... Arguments passed to [shiny::shinyApp()] or [shiny::runGadget()].
#' @name msg_look_app
#' @export
NULL

#' @describeIn msg_look_app Run the msglooker app as a Shiny app.
#' @export
msg_look_app <- function(...) {
	app <- msg_look_shiny()
	shiny::shinyApp(ui = app$ui, server = app$server, ...)
}

#' @describeIn msg_look_app Run the msglooker app as an RStudio Gadget
#' @inheritParams shiny::runGadget
#' @export
msg_look_gadget <- function(..., viewer = shiny::paneViewer()) {
	app <- msg_look_shiny()
	shiny::runGadget(
		app = app$ui,
		server = app$server,
		viewer = viewer,
		...
	)
}


msg_look_shiny <- function() {

	ui <- shiny::basicPage(
		shiny::div(
			class = "col-sm-12 col-md-8 col-md-offset-2",
			shiny::div(
				class="email-container",
				shiny::div(
					class = "email-upload",
					shiny::div(
						class = "well",
						style = "padding-bottom: 0",
						shiny::fileInput('file', "Upload an Email", multiple = FALSE, width = "100%"),
						shiny::div(
							style="margin-top: 10px; margin-bottom: 10px",
							shiny::uiOutput("ui_download")
						)
					)
				),
				shiny::tags$div(
					class = "email-preview",
					shiny::htmlOutput("email")
				)
			)
		),
		shiny::tags$link(rel = "stylesheet", href = "www/msglooker.css"),
		shiny::tags$link(rel = "stylesheet", href = "www/dropzone.css"),
		shiny::tags$script(src = "www/msglooker.js"),
		shiny::tags$script(src = "www/dropzone.js")
	)

	server <- function(input, output, session) {
		tmp_dir <- tempfile("")
		dir.create(tmp_dir, showWarnings = FALSE)
		tmp_email <- file.path(tmp_dir, "email.html")

		shiny::onSessionEnded(function() unlink(tmp_dir, recursive = TRUE))

		output$email <- shiny::renderUI({
			shiny::req(input$file)

			rmarkdown::render(
				input = pkg_file("msglooker.Rmd"),
				output_file = tmp_email,
				output_options = list(title = input$file$name[1]),
				params = list(file = input$file$datapath[1])
			)

			session$sendCustomMessage(
				"msglooker:toggleClass",
				list(selector = ".email-container", cls = "has-email-preview")
			)
			session$sendCustomMessage("msglooker:scrollTo", ".email-preview")
			shiny::htmlTemplate(tmp_email)
		})

		output$ui_download <- shiny::renderUI({
			shiny::req(input$file)
			shiny::downloadButton("download", "Download Email")
		})

		output$download <- shiny::downloadHandler(
			filename = function() {
				paste0(tools::file_path_sans_ext(input$file$name[1]), ".html")
			},
			content = function(file) {
				file.copy(tmp_email, file)
			}
		)
	}

	shiny::addResourcePath("www", pkg_file("www"))
	list(ui = ui, server = server)
}

#' Read and Write an Outlook Message to Self-Contained HTML
#'
#' Read an email saved from Outlook on Windows to a `.msg` file into R, or write
#' an email into a self-contained HTML file.
#'
#' @param path The path to the msg
#' @param output The path to the new HTML file where the email will be saved
#'
#' @export
read_msg <- function(path = file.choose()) {
	msgxtractr::read_msg(path)
}

#' @rdname read_msg
#' @export
msg2html <- function(path = file.choose(), output = file.choose(new = TRUE)) {
	path <- normalizePath(path, mustWork = TRUE)
	output <- normalizePath(output, mustWork = FALSE)
	rmarkdown::render(
		input = pkg_file("msglooker.Rmd"),
		output_file = output,
		output_options = list(title = basename(path)),
		params = list(file = path)
	)
}


pkg_file <- function(...) {
	system.file(..., package = "msglooker", mustWork = TRUE)
}
