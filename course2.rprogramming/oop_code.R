# design a class called “LongitudinalData” that characterizes the structure of this longitudinal dataset
setClass("LongitudinalData", slots = list(df = "data.frame",
	id = "character",
	visit = "integer",
	room = "character"))
# 1. make_LD: a function that converts a data frame into a “LongitudinalData” object	
setGeneric("make_LD", function(x) standardGeneric("make_LD"))
setMethod("make_LD", "data.frame", 
	function(x) {
		x$id <- as.character(x$id)
		x$visit <- as.integer(x$visit)
		x$room <- as.character(x$room)
		ld <- new("LongitudinalData", 
			df = x, 
			id = x$id, 
			visit = x$visit, 
			room = x$room)
	}
)
setMethod("print", "LongitudinalData", 
	function(x) {
		n.subject <- length(unique(x@id))
		cat("Longitudinal dataset with",n.subject , "subjects\n")
})
# 2. subject: a generic function for extracting subject-specific information
# 3. visit: a generic function for extracting visit-specific information
# 4. room: a generic function for extracting room-specific information
setClass("subject", slots = list(s = "character"), 
	contains = "LongitudinalData")
setClass("visit", slots = list(v = "integer"), 
	contains = "subject")
setClass("room", slots = list(r = "character"), 
	contains = "visit")

setGeneric("subject", function(x, subject) standardGeneric("subject"))
setMethod("subject", "LongitudinalData", 
	function(x, subject) {
		subject <- as.character(subject)
		mt <- x@id == subject
		x.subject <- new("subject", 
			s = subject, 
			df = x@df[mt, ],
			id = x@id[mt],
			visit = x@visit[mt],
			room = x@room[mt])
	})
setGeneric("visit", function(x, visit) standardGeneric("visit"))
setMethod("visit", "subject", 
	function(x, visit) {
		visit <- as.integer(visit)
		mt <- x@visit == visit
		x.visit <- new("visit", 
			s = x@s,
			v = visit, 
			df = x@df[mt, ],
			id = x@id[mt],
			visit = x@visit[mt],
			room = x@room[mt])
	})
setGeneric("room", function(x, room) standardGeneric("room"))
setMethod("room", "visit", 
	function(x, room) {
		room <- as.character(room)
		mt <- x@room == room
		x.room <- new("room", 
			s = x@s,
			v = x@v,
			r = room, 
			df = x@df[mt, ],
			id = x@id[mt],
			visit = x@visit[mt],
			room = x@room[mt])
	})
# For each generic/class combination you will need to implement a method, although not all combinations are necessary (see below). You will also need to write print and summary methods for some classes (again, see below).
setMethod("print", "subject", 
	function(x) {
		if (length(x@id) == 0){
			NULL
		} else {
			cat("Subject ID:", x@s, "\n")
		}
	})
setMethod("print", "room",
	function(x) {
		if (length(x@id) == 0){
			NULL
		} else {
			cat("ID:", x@s, "\nVisit:", x@v, "\nRoom:", x@r, "\n")
		}
	})

setClass("summary.subject", slots = list(s = "character", summary = "data.frame"))
setMethod("summary", signature(object = "subject"), 
	function(object) {
		summary.s <- object@df %>% 
			select(visit, room, value) %>% 
			group_by(visit, room) %>% 
			summarize(mean = mean(value)) %>% 
			spread(key = room, value = mean) 
		summary.s <- as.data.frame(summary.s)
		summary.s <- new("summary.subject", s = object@s, summary = summary.s)
	})
setMethod("print", "summary.subject", 
	function(x) {
		cat("ID:", x@s, "\n")
		print(x@summary)
	})

setClass("summary.room", slots = list(s = "character", summary = "table"))
setMethod("summary", signature(object = "room"), 
	function(object) {
		summary.r <- summary(object@df$value) 
		summary.r <- new("summary.room", s = object@s, summary = summary.r)
	})
setMethod("print", "summary.room", 
	function(x) {
		cat("ID:", x@s, "\n")
		print(x@summary)
	})