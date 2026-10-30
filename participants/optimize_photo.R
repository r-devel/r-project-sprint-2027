# script to "optimize" image files in a directory, i.e. reduce to reasonable size for web
library(magick)
library(tools)

## e.g. get all photos in dir
image_dir <- file.path("participants/original-photos")

files <- dir(image_dir, pattern = "jpeg|jpg|png")

files <- "R-PROJECT-SPRINT-2026-9PCFM-2-q292392-sophie_scott.b2d9f3748afc16.jpg"
## remove part before name
out_files <- sub("R-PROJECT-SPRINT-[0-9]{4}-[0-9A-Z]{5}-2-q292392-", "", files)
## remove part after name
out_files <- sub("(.*)[.][^.]*([.].*)", "\\1\\2", out_files)
## ensure underscore not hyphen
out_files <- sub("-", "_", out_files)

## create in optimized sub-directory to start with - don't over-write originals
out_dir <- file.path(image_dir, "optimized")
dir.create(out_dir, showWarnings = FALSE)

for (i in seq_along(files)){
    img <- image_read(file.path(image_dir, files[i]))
    
    # resize to 800 px width, using Triangle filter for resample
    img <- image_resize(img, geometry_size_pixels(height = 800),
                        filter = "Triangle")
    
    # crop to square, keeping the top of the image
    img <- image_crop(img, "800x800", gravity = "center") 
    
    # strip metadata (loses date taken, keep here)
    #img <- image_strip(img)
    
    image_write(img, file.path(out_dir,
                               paste0(file_path_sans_ext(out_files[i]), ".jpg")),
                format = "jpg", quality = 82)    

}

# Check results - if photos have already been reduced in size, results may be 
# worse! May also want to crop before over-writing originals.
