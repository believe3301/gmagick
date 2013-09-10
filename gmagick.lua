local util = require("util")
local ffi = require("ffi")
ffi.cdef([[  typedef void MagickWand;

    typedef void DrawingWand;
    typedef void PixelWand;

    typedef int MagickBooleanType;
    typedef int ExceptionType;
    typedef int ssize_t;
    typedef int CompositeOperator;
    typedef int GravityType;
  
    void InitializeMagick(const char *path);
  
    MagickWand* NewMagickWand();
    MagickWand* DestroyMagickWand(MagickWand*);
    void* MagickRelinquishMemory(void*);
    const char* MagickGetException(const MagickWand*, ExceptionType*);

    //append
    MagickBooleanType MagickAddImage(MagickWand *wand, const MagickWand *add_wand);
    MagickWand *MagickAppendImages(MagickWand *wand, const unsigned int stack);
    void MagickResetIterator(MagickWand *wand);
    MagickBooleanType MagickNextImage(MagickWand *wand);

    //read
    MagickBooleanType MagickReadImage(MagickWand*, const char*);
    MagickBooleanType MagickReadImageBlob(MagickWand*, const void*, const size_t);
  
    int MagickGetImageWidth(MagickWand*);
    int MagickGetImageHeight(MagickWand*);
  
    MagickBooleanType MagickAdaptiveResizeImage(MagickWand*, const size_t, const size_t);
  
    //write
    MagickBooleanType MagickWriteImage(MagickWand*, const char*);
    unsigned char* MagickWriteImageBlob(MagickWand*, size_t*);
  
    //crop
    MagickBooleanType MagickCropImage(MagickWand*,
      const size_t, const size_t, const ssize_t, const ssize_t);

    //blur
    MagickBooleanType MagickBlurImage(MagickWand*, const double, const double);
  
    //format
    MagickBooleanType MagickSetImageFormat(MagickWand* wand, const char* format);
    const char* MagickGetImageFormat(MagickWand* wand);
  
    //quality
    MagickBooleanType MagickSetCompressionQuality(MagickWand *wand, const size_t quality);
  
    MagickBooleanType MagickSharpenImage(MagickWand *wand,
      const double radius,const double sigma);
  
    MagickBooleanType MagickScaleImage(MagickWand *wand,
      const size_t columns,const size_t rows);
  
    //composite
    MagickBooleanType MagickCompositeImage(MagickWand *wand,
      const MagickWand *source_wand,const CompositeOperator compose,
      const ssize_t x,const ssize_t y);

    //query font
    double *MagickQueryFontMetrics(MagickWand *wand, const DrawingWand *drawing_wand,
      const char *text);

    //geometry
    int GetMagickGeometry(const char *geometry,long *x,long *y,unsigned long *width, unsigned long *height);
    int GetGeometry(const char *geometry,long *x,long *y,unsigned long *width, unsigned long *height);

    //draw
    DrawingWand *MagickNewDrawingWand( void );
    void MagickDestroyDrawingWand( DrawingWand *drawing_wand );

    //draw fill color
    void MagickDrawSetFillColor(DrawingWand *drawing_wand, const PixelWand *fill_wand);
    void MagickDrawGetFillColor(const DrawingWand *drawing_wand, PixelWand *fill_color);

    //draw font
    char *MagickDrawGetFont(const DrawingWand *drawing_wand);
    void MagickDrawSetFont(DrawingWand *drawing_wand, const char *font_name);

    //draw font family
    char *MagickDrawGetFontFamily( const DrawingWand *drawing_wand );
    void MagickDrawSetFontFamily( DrawingWand *drawing_wand, const char *font_family );

    //draw font size
    double MagickDrawGetFontSize(const DrawingWand *drawing_wand);
    void MagickDrawSetFontSize( DrawingWand *drawing_wand, const double pointsize );

    //draw gravity
    GravityType MagickDrawGetGravity(const DrawingWand *drawing_wand);
    void MagickDrawSetGravity(DrawingWand *drawing_wand, const GravityType gravity);

    //draw antialias
    unsigned int MagickDrawGetTextAntialias(const DrawingWand *drawing_wand);
    void MagickDrawSetTextAntialias(DrawingWand *drawing_wand, const unsigned int text_antialias);
    unsigned int MagickDrawGetStrokeAntialias(const DrawingWand *drawing_wand);
    void MagickDrawSetStrokeAntialias(DrawingWand *drawing_wand, const unsigned int text_antialias);

    //draw text
    void MagickDrawAnnotation(DrawingWand *drawing_wand, const double x, const double y,
      const unsigned char *text);

    //draw image
    MagickBooleanType MagickDrawImage(MagickWand *wand, const DrawingWand *drawing_wand);

    //montage
    typedef enum
    {
        UndefinedMode,
        FrameMode,
        UnframeMode,
        ConcatenateMode
    } MontageMode;

    MagickWand *MagickMontageImage(MagickWand *wand, const DrawingWand *drawing_wand,
        const char *tile_geometry, const char *thumbnail_geometry, const MontageMode mode, const char *frame);
  
]])
--get ld config
local get_flags
get_flags = function()
    local proc = io.popen("GraphicsMagickWand-config --cppflags --libs", "r")
    local flags = proc:read("*a")
    get_flags = function()
        return flags
    end
    proc:close()
    return flags
end

local io = require "io"
local function perror(obj)
	return io.stderr:write(tostring(obj) .. "\n")
end

local get_filters
get_filters = function()
    local fname = "magick/image.h"
    local prefixes = {
        "/usr/include/GraphicsMagick",
        "/usr/local/include/GraphicsMagick",
        function()
            return get_flags():match("-I([^%s]+)")
        end
    }
    for _index_0 = 1, #prefixes do
        local _continue_0 = false
        repeat
            local p = prefixes[_index_0]
            if "function" == type(p) then
                p = p()
                if not (p) then
                    _continue_0 = true
                    break
                end
            end
            local full = tostring(p) .. "/" .. tostring(fname)
            do
                local f = io.open(full)
                if f then
                    local content
                    do
                        local _with_0 = f:read("*a")
                        f:close()
                        content = _with_0
                    end
                    local filter_types = content:match("(typedef enum.-FilterTypes;)")
                    if filter_types then
                        ffi.cdef(filter_types)
                        return true
                    end
                end
            end
            _continue_0 = true
        until true
        if not _continue_0 then
            break
        end
    end
    return false
end

--load GraphickMagick-Wand
local try_to_load
try_to_load = function(...)
    local out
    local _list_0 = {
        ...
    }
    for _index_0 = 1, #_list_0 do
        local _continue_0 = false
        repeat
            local name = _list_0[_index_0]
            if "function" == type(name) then
                name = name()
                if not (name) then
                    _continue_0 = true
                    break
                end
            end
            if pcall(function()
                out = ffi.load(name)
            end) then
            return out
        end
        _continue_0 = true
    until true
    if not _continue_0 then
        break
    end
end
return error("Failed to load GraphickMagickWand (" .. tostring(...) .. ")")
end
local lib = try_to_load("GraphicsMagickWand", function()
    local lname = get_flags():match("-l(GraphicsMagickWand[^%s]*)")
    local suffix
    if ffi.os == "OSX" then
        suffix = ".dylib"
    elseif ffi.os == "Windows" then
        suffix = ".dll"
    else
        suffix = ".so"
    end
    return lname and "lib" .. lname .. suffix
end)

--Initialize lib
lib.InitializeMagick(nil);

local can_resize
if get_filters() then
    ffi.cdef([[ MagickBooleanType MagickResizeImage(MagickWand*,
    const size_t, const size_t,
    const FilterTypes, const double);
    ]])
    can_resize = true
end

local composite_op = {
  ["UndefinedCompositeOp"] = lib.UndefinedCompositeOp,
  ["OverCompositeOp"] = lib.OverCompositeOp,
  ["InCompositeOp"] = lib.InCompositeOp,
  ["OutCompositeOp"] = lib.OutCompositeOp,
  ["AtopCompositeOp"] = lib.AtopCompositeOp,
  ["XorCompositeOp"] = lib.XorCompositeOp,
  ["PlusCompositeOp"] = lib.PlusCompositeOp,
  ["MinusCompositeOp"] = lib.MinusCompositeOp,
  ["AddCompositeOp"] = lib.AddCompositeOp,
  ["SubtractCompositeOp"] = lib.SubtractCompositeOp,
  ["DifferenceCompositeOp"] = lib.DifferenceCompositeOp,
  ["MultiplyCompositeOp"] = lib.MultiplyCompositeOp,
  ["BumpmapCompositeOp"] = lib.BumpmapCompositeOp,
  ["CopyCompositeOp"] = lib.CopyCompositeOp,
  ["CopyRedCompositeOp"] = lib.CopyRedCompositeOp,
  ["CopyGreenCompositeOp"] = lib.CopyGreenCompositeOp,
  ["CopyBlueCompositeOp"] = lib.CopyBlueCompositeOp,
  ["CopyOpacityCompositeOp"] = lib.CopyOpacityCompositeOp,
  ["ClearCompositeOp"] = lib.ClearCompositeOp,
  ["DissolveCompositeOp"] = lib.DissolveCompositeOp,
  ["DisplaceCompositeOp"] = lib.DisplaceCompositeOp,
  ["ModulateCompositeOp"] = lib.ModulateCompositeOp,
  ["ThresholdCompositeOp"] = lib.ThresholdCompositeOp,
  ["NoCompositeOp"] = lib.NoCompositeOp,
  ["DarkenCompositeOp"] = lib.DarkenCompositeOp,
  ["LightenCompositeOp"] = lib.LightenCompositeOp,
  ["HueCompositeOp"] = lib.HueCompositeOp,
  ["SaturateCompositeOp"] = lib.SaturateCompositeOp,
  ["ColorizeCompositeOp"] = lib.ColorizeCompositeOp,
  ["LuminizeCompositeOp"] = lib.LuminizeCompositeOp,
  ["ScreenCompositeOp"] = lib.ScreenCompositeOp,
  ["OverlayCompositeOp"] = lib.OverlayCompositeOp,
  ["CopyCyanCompositeOp"] = lib.CopyCyanCompositeOp,
  ["CopyMagentaCompositeOp"] = lib.CopyMagentaCompositeOp,
  ["CopyYellowCompositeOp"] = lib.CopyYellowCompositeOp,
  ["CopyBlackCompositeOp"] = lib.CopyBlackCompositeOp,
  ["DivideCompositeOp"] = lib.DivideCompositeOp,
}

local gravity_str = {
  "ForgetGravity",
  "NorthWestGravity",
  "NorthGravity",
  "NorthEastGravity",
  "WestGravity",
  "CenterGravity",
  "EastGravity",
  "SouthWestGravity",
  "SouthGravity",
  "SouthEastGravity",
  "StaticGravity"
}
local gravity_type = { }
for i, t in ipairs(gravity_str) do
  gravity_type[t] = i
end

local filter
filter = function(name)
    return lib[name .. "Filter"]
end

local get_exception
get_exception = function(wand)
  local etype = ffi.new("ExceptionType[1]", 0)
  local msg = ffi.string(lib.MagickGetException(wand, etype))
  return etype[0], msg
end
local handle_result
handle_result = function(img_or_wand, status)
  local wand = img_or_wand.wand or img_or_wand
  if status == 0 then
    local code, msg = get_exception(wand)
    return nil, msg, code
  else
    return true
  end
end

local tonumber = tonumber
local parse_size_str
parse_size_str = function(str, src_w, src_h)
    local w, h, rest = str:match("^(%d*%%?)x(%d*%%?)(.*)$")
    if not w then
        return nil, "failed to parse string (" .. tostring(str) .. ")"
    end
    do
        local p = w:match("(%d+)%%")
        if p then
            w = tonumber(p) / 100 * src_w
        else
            w = tonumber(w)
        end
    end
    do
        local p = h:match("(%d+)%%")
        if p then
            h = tonumber(p) / 100 * src_h
        else
            h = tonumber(h)
        end
    end
    local center_crop = rest:match("#") and true
    if w and h and not center_crop then
        if not (rest:match("!")) then
            if src_w / src_h > w / h then
                h = nil
            else
                w = nil
            end
        end
    end
    local crop_x, crop_y = rest:match("%+(%d+)%+(%d+)")
    if crop_x then
        crop_x = tonumber(crop_x)
        crop_y = tonumber(crop_y)
    end
    return {
        w = w,
        h = h,
        crop_x = crop_x,
        crop_y = crop_y,
        center_crop = center_crop
    }
end

local get_image_position
local get_image_position = function(img_w, img_h, geometry, gravity)
    local x = ffi.new("long[1]", 0)
    local y = ffi.new("long[1]", 0)
    local w = ffi.new("unsigned long[1]", img_w)
    local h = ffi.new("unsigned long[1]", img_h)

    local r = lib.GetMagickGeometry(geometry, x, y, w, h)

    local r_x = x[0]
    local r_y = y[0]
    local r_w = w[0] 
    local r_h = h[0]

    if(gravity == nil or gravity == "NorthWestGravity") then

    elseif (gravity == "NorthGravity") then
        r_x = r_x + (img_w/2-r_w/2)

    elseif (gravity == "NorthEastGravity") then
        r_x = (img_w-r_x);

    elseif (gravity == "WestGravity") then
        r_y = r_y + (img_h/2-r_h/2)

    elseif (gravity == "CenterGravity") then 
        r_x = r_x + (img_w/2-r_w/2)
        r_y = r_y + (img_h/2-r_h/2)

    elseif (gravity == "EastGravity") then
        r_x = (img_w-r_w-r_x);
        r_y = r_y + (img_h/2-r_h/2)

    elseif (gravity == "SouthWestGravity") then
      r_y = (img_h-r_h-r_y)

    elseif (gravity == "SouthGravity") then
      r_x = r_x + (img_w/2-r_w/2);
      r_y = (img_h-r_h-r_y)

    elseif (gravity == "SouthEastGravity") then
      r_x= (img_w-r_w-r_x)
      r_y= (img_h-r_h-r_y)
    end

  return {w = r_w, h = r_h, x = r_x, y = r_y}
end

local Draw
do
    local _base_0 = {
        get_font = function(self)
            return lib.MagickDrawSetFont(self.wand)
        end,

        set_font = function(self, font)
            lib.MagickDrawSetFont(self.wand, font)
        end,

        get_fontfamily = function(self)
            return lib.MagickDrawGetFontFamily(self.wand)
        end,

        set_fontfamily = function(self, family)
            lib.MagickDrawSetFontFamily(self.wand, family)
        end,

        get_fontsize = function(self)
            return lib.MagickDrawGetFontSize(self.wand)
        end,

        set_fontsize = function(self, fsize)
            lib.MagickDrawSetFontSize(self.wand, fsize)
        end,

        get_gravity = function(self)
            return lib.MagickDrawGetGravity(self.wand)
        end,

        set_gravity = function(self, typestr)
            local g = gravity_type[typestr]
            if not (g) then
                error("invalid gravity type")
            end
            lib.MagickDrawSetGravity(self.wand, g)
        end,

        set_text_antialias = function(self, antialias)
            lib.MagickDrawSetTextAntialias(self.wand, antialias)
        end,

        get_text_antialias = function(self)
            return lib.MagickDrawGetTextAntialias(self.wand)
        end,

        set_stroke_antialias = function(self, antialias)
            lib.MagickDrawSetStrokeAntialias(self.wand, antialias)
        end,

        get_stroke_antialias = function(self)
            return lib.MagickDrawGetStrokeAntialias(self.wand)
        end,

        annotate = function(self, x, y, text)
            return lib.MagickDrawAnnotation(self.wand, x, y, text)
        end,

        destroy = function(self)
            if self.wand then
                lib.MagickDestroyDrawingWand(self.wand)
            end
            self.wand = nil
        end,

    }
    _base_0.__index = _base_0
    local _class_0 = setmetatable({
        __init = function(self)
            self.wand = lib.MagickNewDrawingWand()
            if not (self.wand) then
                error("new drawing wand")
            end
        end,
        __base = _base_0,
        __name = "Draw"
    }, {
        __index = _base_0,
        __call = function(cls, ...)
            local _self_0 = setmetatable({}, _base_0)
            cls.__init(_self_0, ...)
            return _self_0
        end
    })
    _base_0.__class = _class_0
    Draw = _class_0
end


local Image
do
    local _base_0 = {
        --width
        get_width = function(self)
            return lib.MagickGetImageWidth(self.wand)
        end,

        --height
        get_height = function(self)
            return lib.MagickGetImageHeight(self.wand)
        end,

        --format
        get_format = function(self)
            return ffi.string(lib.MagickGetImageFormat(self.wand)):lower()
        end,
        set_format = function(self, format)
            return handle_result(self, lib.MagickSetImageFormat(self.wand, format))
        end,

        --quality
        set_quality = function(self, quality)
            return handle_result(self, lib.MagickSetCompressionQuality(self.wand, quality))
        end,

        --gravity
        get_gravity = function(self)
            return self.gravity
        end,

        set_gravity = function(self, typestr)
            local g = gravity_type[typestr]
            if not (g) then
                error("invalid gravity type")
            end
            self.gravity = typestr
            return 0
        end,

        --compute position by gravity
        _keep_aspect = function(self, geometry)
            if (geometry) then
                local g = get_image_position(self:get_width(), self:get_height(), geometry, self.gravity)
                return g.w, g.h, g.x, g.y
            end
            return self:get_width(), self:get_height(), 0, 0
        end,

        --clone
        clone = function(self)
            local wand = lib.NewMagickWand()
            lib.MagickAddImage(wand, self.wand)
            return Image(wand, self.path)
        end,

        --resize
        resize = function(self, geometry, f, blur)
            if f == nil then
                f = "Cubic"
            end
            if blur == nil then
                blur = 1.0
            end
            if not (can_resize) then
                error("Failed to load filter list, can't resize")
            end
            local w, h = self:_keep_aspect(geometry)
            return handle_result(self, lib.MagickResizeImage(self.wand, w, h, filter(f), blur))
        end,

        adaptive_resize = function(self, geometry)
            local w, h = self:_keep_aspect(geometry)
            return handle_result(self, lib.MagickAdaptiveResizeImage(self.wand, w, h))
        end,

        scale = function(self, geometry)
            local w, h = self:_keep_aspect(geometry)
            return handle_result(self, lib.MagickScaleImage(self.wand, w, h))
        end,

        --crop
        crop = function(self, geometry)
            local w, h, x, y = self:_keep_aspect(geometry)
            return handle_result(self, lib.MagickCropImage(self.wand, w, h, x, y))
        end,

        blur = function(self, sigma, radius)
            if radius == nil then
                radius = 0
            end
            return handle_result(self, lib.MagickBlurImage(self.wand, radius, sigma))
        end,

        sharpen = function(self, sigma, radius)
            if radius == nil then
                radius = 0
            end
            return handle_result(self, lib.MagickSharpenImage(self.wand, radius, sigma))
        end,

        --composite
        composite = function(self, blob, geometry, opstr)
            if opstr == nil then
                opstr = "OverCompositeOp"
            end
            local op = composite_op[opstr]
            if not (op) then
                error("invalid operator type")
            end
            local _, _, x, y = self:_keep_aspect(geometry)
            return handle_result(self, lib.MagickCompositeImage(self.wand, blob, op, x, y))
        end,

        --get blob
        get_blob = function(self)
            local len = ffi.new("size_t[1]", 0)
            local blob = lib.MagickWriteImageBlob(self.wand, len)
            do
                local _with_0 = ffi.string(blob, len[0])
                lib.MagickRelinquishMemory(blob)
                return _with_0
            end
        end,

        -- write
        write = function(self, fname)
            return handle_result(self, lib.MagickWriteImage(self.wand, fname))
        end,

        -- query font
        query_font_metrics = function(self, draw, text)
            local r = lib.MagickQueryFontMetrics(self.wand, draw.wand, text)
            local t = { 
                width = r[0], height = r[1], ascender = r[2],
                descender = r[3], text = r[4], text_height = r[5], max_horizontal = r[6]
            }
            util.dumptable(t)
            return t
        end,

        --draw image
        draw_image = function(self, draw)
            return handle_result(self, lib.MagickDrawImage(self.wand, draw.wand))
        end,

        --add image
        add_image = function(self, img)
            return handle_result(self, lib.MagickAddImage(self.wand, img.wand))
        end,

        --load image
        reset_iterator = function(self)
            lib.MagickResetIterator(self.wand)
        end,


        append = function(self, stack)
            if not stack then
                stack = false
            end

            local w = lib.MagickAppendImages(self.wand, stack)
            if w then
                return Image(w, "<Append>")
            end

            return nil
        end,

        destroy = function(self)
            if self.wand then
                lib.DestroyMagickWand(self.wand)
            end
            self.wand = nil
        end,

        __tostring = function(self)
            return "Image<" .. tostring(self.path) .. ", " .. tostring(self.wand) .. ">"
        end
    }
    _base_0.__index = _base_0
    local _class_0 = setmetatable({
        __init = function(self, wand, path)
            self.wand, self.path, self.gravity = wand, path, nil
        end,
        __base = _base_0,
        __name = "Image"
    }, {
        __index = _base_0,
        __call = function(cls, ...)
            local _self_0 = setmetatable({}, _base_0)
            cls.__init(_self_0, ...)
            return _self_0
        end
    })
    _base_0.__class = _class_0
    Image = _class_0
end

--load image
local load_image
load_image = function(path)
    local wand = lib.NewMagickWand()
    if 0 == lib.MagickReadImage(wand, path) then
        local code, msg = get_exception(wand)
        lib.DestroyMagickWand(wand)
        return nil, msg, code
    end
    return Image(wand, path)
end

--load image from blob
local load_image_from_blob
load_image_from_blob = function(blob)
    local wand = lib.NewMagickWand()
    if 0 == lib.MagickReadImageBlob(wand, blob, #blob) then
        local code, msg = get_exception(wand)
        lib.DestroyMagickWand(wand)
        return nil, msg, code
    end
    return Image(wand, "<from_blob>")
end

local join_str
join_str = function(str1, str2)
    if (str1 and str2) then
        return str1 .. str2
    end

    if (str1) then
        return str1
    end

    if (str2) then
        return str2
    end

    return nil
end

--load new image
local new_image
new_image = function(cols, rows, color)
    local wand = lib.NewMagickWand()
    local path
    
    if not color then
        color = "None"
    end
    
    path = "xc:" .. color

    if 0 == lib.MagickReadImage(wand, path) then
        local code, msg = get_exception(wand)
        lib.DestroyMagickWand(wand)
        return nil, join_str("read image error.", msg), code
    end

    if 0 == lib.MagickScaleImage(wand, cols, rows) then
        local code, msg = get_exception(wand)
        lib.DestroyMagickWand(wand)
        return nil, join_str("scale image error.", msg), code
    end

    return Image(wand, "<new_image>")
end

--thumb
local thumb
thumb = function(img, size_str, output)
    if type(img) == "string" then
        img = assert(load_image(img))
    end
    local src_w, src_h = img:get_width(), img:get_height()
    local opts = parse_size_str(size_str, src_w, src_h)
    if opts.center_crop then
        img:resize_and_crop(opts.w, opts.h)
    elseif opts.crop_x then
        img:crop(opts.w, opts.h, opts.crop_x, opts.crop_y)
    else
        img:resize(opts.w, opts.h)
    end
    local ret
    if output then
        ret = img:write(output)
    else
        ret = img:get_blob()
    end
    img:destroy()
    return ret
end

if ... == "test" then
    local w, h = 500, 300
    local D
    D = function(t)
        return print(table.concat((function()
            local _accum_0 = { }
            local _len_0 = 1
            for k, v in pairs(t) do
                _accum_0[_len_0] = tostring(k) .. ": " .. tostring(v)
                _len_0 = _len_0 + 1
            end
            return _accum_0
        end)(), ", "))
    end
    D(parse_size_str("10x10", w, h))
    D(parse_size_str("50%x50%", w, h))
    D(parse_size_str("50%x50%!", w, h))
    D(parse_size_str("x10", w, h))
    D(parse_size_str("10x%", w, h))
    D(parse_size_str("10x10%#", w, h))
    D(parse_size_str("200x300", w, h))
    D(parse_size_str("200x300!", w, h))
    D(parse_size_str("200x300+10+10", w, h))
end

return {
    load_image = load_image,
    load_image_from_blob = load_image_from_blob,
    new_image = new_image,
    thumb = thumb,
    Image = Image,
    Draw = Draw
}
