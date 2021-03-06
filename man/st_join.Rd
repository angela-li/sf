% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/join.R
\name{st_join}
\alias{st_join}
\title{spatial left or inner join}
\usage{
st_join(x, y, join = st_intersects, FUN, suffix = c(".x", ".y"), ...,
  left = TRUE, largest = FALSE)
}
\arguments{
\item{x}{object of class \code{sf}}

\item{y}{object of class \code{sf}}

\item{join}{geometry predicate function with the same profile as \link{st_intersects}; see details}

\item{FUN}{deprecated;}

\item{suffix}{length 2 character vector; see \link[base]{merge}}

\item{...}{arguments passed on to the \code{join} function (e.g. \code{prepared}, or a pattern for \link{st_relate})}

\item{left}{logical; if \code{TRUE} carry out left join, else inner join; 
see also \link[dplyr]{left_join}}

\item{largest}{logical; if \code{TRUE}, return \code{x} features augmented with the fields of \code{y} that have the largest overlap with each of the features of \code{x}; see https://github.com/r-spatial/sf/issues/578}
}
\value{
an object of class \code{sf}, joined based on geometry
}
\description{
spatial left or inner join
}
\details{
alternative values for argument \code{join} are: \link{st_disjoint}
\link{st_touches} \link{st_crosses} \link{st_within} \link{st_contains}
\link{st_overlaps} \link{st_covers} \link{st_covered_by} \link{st_equals} or
\link{st_equals_exact}, or user-defined functions of the same profile
}
\examples{
a = st_sf(a = 1:3,
 geom = st_sfc(st_point(c(1,1)), st_point(c(2,2)), st_point(c(3,3))))
b = st_sf(a = 11:14,
 geom = st_sfc(st_point(c(10,10)), st_point(c(2,2)), st_point(c(2,2)), st_point(c(3,3))))
st_join(a, b)
st_join(a, b, left = FALSE)
# two ways to aggregate y's attribute values outcome over x's geometries:
st_join(a, b) \%>\% aggregate(list(.$a.x), mean)
library(dplyr)
st_join(a, b) \%>\% group_by(a.x) \%>\% summarise(mean(a.y))
# example of largest = TRUE:
nc <- st_transform(st_read(system.file("shape/nc.shp", package="sf")), 2264)                
gr = st_sf(
    label = apply(expand.grid(1:10, LETTERS[10:1])[,2:1], 1, paste0, collapse = " "),
    geom = st_make_grid(nc))
gr$col = sf.colors(10, categorical = TRUE, alpha = .3)
# cut, to check, NA's work out:
gr = gr[-(1:30),]
nc_j <- st_join(nc, gr, largest = TRUE)
# the two datasets:
opar = par(mfrow = c(2,1), mar = rep(0,4))
plot(st_geometry(nc_j))
plot(st_geometry(gr), add = TRUE, col = gr$col)
text(st_coordinates(st_centroid(gr)), labels = gr$label)
# the joined dataset:
plot(st_geometry(nc_j), border = 'black', col = nc_j$col)
text(st_coordinates(st_centroid(nc_j)), labels = nc_j$label, cex = .8)
plot(st_geometry(gr), border = 'green', add = TRUE)
par(opar)
}
