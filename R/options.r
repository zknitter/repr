#' repr options
#' 
#' These options are used to control the behavior of repr when not calling it directly.
#' Use \code{\link[base]{options}(repr.* = ...)} and \code{\link[base]{getOption}('repr.*')}
#' to set and get them, respectively.
#' \code{plot_options} is a convenience function to reset the plot to defaults (overriding some)
#' 
#' Once this package is loaded, all options are set to defaults which weren’t set beforehand.
#' 
#' Setting all options set to \code{NULL} are reset to defaults when reloading the package (or calling \code{repr:::.onload()}).
#' 
#' @param width      Plotting area width in inches (default: 7)
#' @param height     Plotting area height in inches (default: 7)
#' @param pointsize  Text height in pt (default: 12)
#' @param bg         Background color (default: white)
#' @param antialias  Which kind of antialiasing to use for for lines and text? 'gray', 'subpixel' or 'none'? (default: gray)
#' @param res        PPI for rasterization (default: 120)
#' @param quality    Quality of JPEG format in \% (default: 90)
#' @param family     Vector font family. 'sans', 'serif', 'mono' or a specific one (default: sans)
#' 
#' @section Options:
#' 
#' \describe{
#' 
#' \item{\code{repr.plot.*}}{
#' 	Those are for representations of \code{recordedplot} instances. See \emph{Arguments}
#' }
#' \item{\code{repr.vector.quote}}{
#' 	Output quotation marks for character vectors? (default: TRUE)
#' }
#' \item{\code{repr.matrix.max.rows}}{
#' 	How many rows to display at max. Will insert a row with vertical ellipses to show elision. (default: 60)
#' }
#' \item{\code{repr.matrix.max.cols}}{
#' 	How many cols to display at max. Will insert a column with horizontal ellipses to show elision. (default: 20)
#' }
#' \item{\code{repr.matrix.latex.colspec}}{
#' 	How to layout LaTeX tables when representing matrices or data.frames.
#' 	List of \code{row.head}, other \code{col}, and \code{end} strings.
#' 	\code{end} mainly exists for when you want a vertical line there (default: 'r|', 'l', and '')
#' }
#' \item{\code{repr.function.highlight}}{
#'  Use the \code{highr} package to insert highlighting instructions into the code? Needs that package to be installed. (default: FALSE)
#' }
#' \item{\code{repr.html.deduplicate}}{
#'  Use the \link{html_dependencies} manager to only include dependencies once? This can greatly reduce notebook size, but fails if e.g. iframes are used (default: FALSE)
#' }
#' 
#' }
#'
#' @name repr-options
NULL

plot_defaults <- list(
	repr.plot.width     = 7,
	repr.plot.height    = 7,
	repr.plot.pointsize = 12,
	repr.plot.bg        = 'white',
	repr.plot.antialias = 'gray',
	#nice medium-res DPI
	repr.plot.res       = 120,
	#jpeg quality bumped from default
	repr.plot.quality   = 90,
	#vector font family
	repr.plot.family    = 'sans')

class_defaults <- list(
	repr.vector.quote = TRUE,
	repr.matrix.max.rows = 60,
	repr.matrix.max.cols = 20,
	repr.matrix.latex.colspec = list(row_head = 'r|', col = 'l', end = ''),
	repr.function.highlight = FALSE,
	repr.html.deduplicate = FALSE)

#' @name repr-options
#' @export
repr_option_defaults <- c(plot_defaults, class_defaults)


#' @name repr-options
#' @export
plot_options <- function(...) {
	env <- environment()
	arg_names <- formalArgs(plot_options)
	arg_spec <- sapply(arg_names, get, env)
	names(arg_spec) <- paste0('repr.plot.', arg_names)
	do.call(options, arg_spec)
}
formals(plot_options) <- local({
	args <- plot_defaults
	names(args) <- sub('^repr[.]plot[.]', '', names(args))
	as.pairlist(args)
})

.onLoad <- function(libname = NULL, pkgname = NULL) {
	for (opt_name in names(repr_option_defaults)) {
		if (is.null(getOption(opt_name)))
			do.call(options, repr_option_defaults[opt_name])  # single []: name stays
	}
}
