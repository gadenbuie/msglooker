const toggleClass = ({selector, cls, state}) => {
	state = state || true
  let  els = document.querySelectorAll(selector)
  if (!els) return
  [...els].forEach(el => {
    el.classList.toggle(cls, state)
  })
}

Shiny.addCustomMessageHandler('msglooker:toggleClass', toggleClass)

const scrollTo = (selector) => {
	setTimeout(() => {
	  document.querySelector(selector).scrollIntoView()
	}, 500)
}

Shiny.addCustomMessageHandler('msglooker:scrollTo', scrollTo)
