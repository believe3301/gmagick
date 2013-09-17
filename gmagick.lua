local string = require("string")
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
    MagickBooleanType DestroyMagickWand(MagickWand*);
    void* MagickRelinquishMemory(void*);
    const char* MagickGetException(const MagickWand*, ExceptionType*);

    MagickWand *MagickGetImage(MagickWand *wand);

    MagickBooleanType MagickSetSize( MagickWand *wand, const unsigned long columns, const unsigned long rows );

    //filename
    MagickBooleanType MagickSetImageFilename( MagickWand *wand, const char *filename);
    const char* MagickGetImageFilename(MagickWand *wand );

    MagickBooleanType MagickSetFilename(MagickWand *wand, const char *filename);
    const char* MagickGetFilename(MagickWand *wand);

    //image list
    unsigned long MagickGetNumberImages( MagickWand *wand );
    MagickBooleanType MagickAddImage(MagickWand *wand, const MagickWand *add_wand);
    MagickBooleanType MagickRemoveImage( MagickWand *wand );
    MagickBooleanType MagickSetImageIndex( MagickWand *wand, const long index );
    MagickBooleanType MagickNextImage( MagickWand *wand );
    MagickBooleanType MagickPreviousImage( MagickWand *wand );
    MagickBooleanType MagickHasNextImage( MagickWand *wand );
    MagickBooleanType MagickHasPreviousImage( MagickWand *wand );
    MagickBooleanType MagickSetImage(MagickWand *wand, const MagickWand *set_wand);

    //append
    MagickWand *MagickAppendImages(MagickWand *wand, const unsigned int stack);
    void MagickResetIterator(MagickWand *wand);

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
    MagickBooleanType IsGeometry(const char *geometry);

    //Pixel
    PixelWand *NewPixelWand(void);
    void DestroyPixelWand(PixelWand *wand);
    MagickBooleanType PixelSetColor(PixelWand *wand, const char *color);
    char *PixelGetColorAsString(PixelWand *wand);

    //draw
    DrawingWand *MagickNewDrawingWand( void );
    void MagickDestroyDrawingWand( DrawingWand *drawing_wand );

    //draw fill color
    void MagickDrawSetFillColor(DrawingWand *drawing_wand, const PixelWand *fill_wand);
    void MagickDrawGetFillColor(const DrawingWand *drawing_wand, PixelWand *fill_color);
    void MagickDrawSetStrokeColor(DrawingWand *drawing_wand, const PixelWand *stroke_wand);
    void MagickDrawGetStrokeColor(const DrawingWand *drawing_wand, PixelWand *stroke_color);
    double MagickDrawGetStrokeWidth(const DrawingWand *drawing_wand);
    void MagickDrawSetStrokeWidth(DrawingWand *drawing_wand, const double stroke_width);

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

    //draw
    void MagickDrawAnnotation(DrawingWand *drawing_wand, const double x, const double y,
      const unsigned char *text);

    //draw rectangle
    void MagickDrawRectangle(DrawingWand *drawing_wand, const double x1, const double y1,
        const double x2, const double y2 );

    void MagickDrawRoundRectangle( DrawingWand *drawing_wand, double x1, double y1, double x2, double y2,
        double rx, double ry );

    void MagickDrawCircle(DrawingWand *drawing_wand, const double ox, const double oy, const double px,
        const double py );

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
--lib.InitializeMagick("luabinding");

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
  local blob = lib.MagickGetException(wand, etype)
  local msg = ""
  
  if tonumber(ffi.cast("intptr_t", blob)) ~= 0 then
      msg  = ffi.string(blob)
      lib.MagickRelinquishMemory(blob)
  end
  return tonumber(etype[0]), msg
end

local handle_result
handle_result = function(wand, status)
  local wand = wand
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

local is_geometry
is_geometry = function(geometry)
    local r = lib.IsGeometry(geometry)
    return r == 1 
end

local get_geometry
get_geometry = function(geometry)
    local x = ffi.new("long[1]", 0)
    local y = ffi.new("long[1]", 0)
    local w = ffi.new("unsigned long[1]", 0)
    local h = ffi.new("unsigned long[1]", 0)

    local f = lib.GetGeometry(geometry, x, y, w, h);
    return f, {x = tonumber(x[0]), y = tonumber(y[0]), w = tonumber(w[0]), h = tonumber(h[0])}
end

local get_image_position
local get_image_position = function(img_w, img_h, geometry, gravity, size_to_fit)
    local x = ffi.new("long[1]", 0)
    local y = ffi.new("long[1]", 0)
    local w = ffi.new("unsigned long[1]", img_w)
    local h = ffi.new("unsigned long[1]", img_h)
    local geometry = geometry
    local gravity = gravity

    if (not geometry) then
        return nil
    end

    if (not size_to_fit) then
        geometry = geometry .. "!"
    end

    local r = lib.GetMagickGeometry(geometry, x, y, w, h)

    local r_x = tonumber(x[0])
    local r_y = tonumber(y[0])
    local r_w = tonumber(w[0])
    local r_h = tonumber(h[0])

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

  return r_w, r_h, r_x, r_y
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


local Draw
do
    local _base_0 = {
        set_fillcolor = function(self, color)
            tmpwand = lib.NewPixelWand()
            local r, msg, code= handle_result(tmpwand, lib.PixelSetColor(tmpwand, color))
            if not r then
                lib.DestroyPixelWand(tmpwand)
                return r, msg, code
            end
            
            lib.MagickDrawSetFillColor(self.wand, tmpwand)
            lib.DestroyPixelWand(tmpwand)
            return true
        end, 

        get_stroke_width = function(self)
            return lib.MagickDrawGetStrokeWidth(self.wand)
        end,

        set_stroke_width = function(self, width)
            lib.MagickDrawSetStrokeWidth(self.wand, width)
        end,

        get_stroke_color = function(self)
            tmpwand = lib.NewPixelWand()
            lib.MagickDrawGetStrokeColor(self.wand, tmpwand)
            local color = lib.PixelGetColorAsString(tmpwand)
            lib.DestroyPixelWand(tmpwand)
            return ffi.string(color)
        end,

        set_stroke_color = function(self, color)
            tmpwand = lib.NewPixelWand()
            local r, msg, code= handle_result(tmpwand, lib.PixelSetColor(tmpwand, color))
            if not r then
                lib.DestroyPixelWand(tmpwand)
                return r, msg, code
            end
            
            lib.MagickDrawSetStrokeColor(self.wand, tmpwand)
            lib.DestroyPixelWand(tmpwand)
            return true
        end,

        draw_rectangle = function(self, x1, y1, x2, y2)
            lib.MagickDrawRectangle(self.wand, x1, y1, x2, y2)
        end,

        draw_circle = function(self, ox, oy, px, py)
            lib.MagickDrawCircle(self.wand, ox, oy, px, py)
        end,

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
            return tonumber(lib.MagickGetImageWidth(self.wand))
        end,

        --height
        get_height = function(self)
            return tonumber(lib.MagickGetImageHeight(self.wand))
        end,

        --format
        get_format = function(self)
            return ffi.string(lib.MagickGetImageFormat(self.wand)):lower()
        end,

        set_format = function(self, format)
            return handle_result(self.wand, lib.MagickSetImageFormat(self.wand, format))
        end,

        --filename
        get_filename = function(self)
            return ffi.string(lib.MagickGetFilename(self.wand))
        end,

        set_filename = function(self, filename)
            return handle_result(self.wand, lib.MagickSetFilename(self.wand, filename))
        end,

        get_image_filename = function(self)
            return ffi.string(lib.MagickGetImageFilename(self.wand))
        end,

        set_image_filename = function(self, filename)
            return handle_result(self.wand, lib.MagickSetImageFilename(self.wand, filename))
        end,

        --quality
        set_quality = function(self, quality)
            return handle_result(self.wand, lib.MagickSetCompressionQuality(self.wand, quality))
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
        _keep_aspect = function(self, geometry, size_to_fit, gravity)
            return get_image_position(self:get_width(), self:get_height(), geometry, gravity, size_to_fit)
        end,

        --clone
        clone = function(self)
            --[[
            local wand = lib.NewMagickWand()
            lib.MagickAddImage(wand, self.wand)
            ]]
            local wand = lib.MagickGetImage(self.wand)
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
            local w, h = self:_keep_aspect(geometry, true)
            if w == 0 or h == 0 or (w == self:get_width() and h == self:get_height()) then
                return true
            end
            return handle_result(self.wand, lib.MagickResizeImage(self.wand, w, h, filter(f), blur))
        end,

        scale = function(self, geometry)
            local w, h = self:_keep_aspect(geometry)
            return handle_result(self.wand, lib.MagickScaleImage(self.wand, w, h))
        end,

        --crop
        crop = function(self, geometry)
            local w, h, x, y = self:_keep_aspect(geometry)
            return handle_result(self.wand, lib.MagickCropImage(self.wand, w, h, x, y))
        end,

        blur = function(self, sigma, radius)
            if radius == nil then
                radius = 0
            end
            return handle_result(self.wand, lib.MagickBlurImage(self.wand, radius, sigma))
        end,

        sharpen = function(self, sigma, radius)
            if radius == nil then
                radius = 0
            end
            return handle_result(self.wand, lib.MagickSharpenImage(self.wand, radius, sigma))
        end,

        --composite
        composite = function(self, img, geometry, opstr)
            local _, g = get_geometry(geometry)
            local c_geometry = string.format("%dx%d+%d+%d", img:get_width(), img:get_height(), g["x"], g["y"])

            if opstr == nil then
                opstr = "OverCompositeOp"
            end
            local op = composite_op[opstr]
            if not (op) then
                error("invalid operator type")
            end

            local _, _, x, y = self:_keep_aspect(c_geometry, false, img:get_gravity())
            return handle_result(self.wand, lib.MagickCompositeImage(self.wand, img.wand, op, x, y))
        end,

        --get blob
        get_blob = function(self)
            self:reset_iterator()
            local len = ffi.new("size_t[1]", 0)
            local blob = lib.MagickWriteImageBlob(self.wand, len)

            if tonumber(ffi.cast("intptr_t", blob)) ~= 0 then
                local _with_0 = ffi.string(blob, len[0])
                lib.MagickRelinquishMemory(blob)
                return _with_0
            end

            local code, msg = get_exception(self.wand)
            return nil, msg, code
        end,

        -- write
        write = function(self, fname)
            return handle_result(self.wand, lib.MagickWriteImage(self.wand, fname))
        end,

        -- query font
        query_font_metrics = function(self, draw, text)
            local r = lib.MagickQueryFontMetrics(self.wand, draw.wand, text)
            local t = { 
                width = r[0], height = r[1], ascender = r[2],
                descender = r[3], text = r[4], text_height = r[5], max_horizontal = r[6]
            }
            return t
        end,

        --draw image
        draw_image = function(self, draw)
            return handle_result(self.wand, lib.MagickDrawImage(self.wand, draw.wand))
        end,

        remove_image = function(self)
            return handle_result(self.wand, lib.MagickRemoveImage(self.wand))
        end, 

        set_image_index = function(self, index)
            return handle_result(self.wand, lib.MagickSetImageIndex(self.wand, index))
        end,

        next_image = function(self)
            return handle_result(self.wand, lib.MagickNextImage(self.wand))
        end,

        prev_image = function(self)
            return handle_result(self.wand, lib.MagickPreviousImage(self.wand))
        end,

        set_image = function(self, img)
            return handle_result(self.wand, lib.MagickSetImage(self.wand, img.wand))
        end,

        get_image_num = function(self)
            return tonumber(lib.MagickGetNumberImages(self.wand))
        end,

        -- read image
        read_image = function(self, path)
            return handle_result(self.wand, lib.MagickReadImage(self.wand, path))
        end,

        -- read blob image
        read_image_blob = function(self, blob)
            return handle_result(self.wand, lib.MagickReadImageBlob(self.wand, blob, #blob))
        end,

        -- new_image
        new_image = function(self, cols, rows, color)
            local wand = self.wand

            if not color then
                color = "None"
            end

            local path = "xc:" .. color
            local r, code, msg = handle_result(wand, lib.MagickSetSize(wand, cols, rows))

            if not r then
                return nil, join_str("set size error.", msg), code
            end

            local r, code, msg = lib.MagickReadImage(wand, path)

            if not r then
                return nil, join_str("read image error.", msg), code
            end
            return true
        end,

        --add image
        add_image = function(self, img)
            return handle_result(self.wand, lib.MagickAddImage(self.wand, img.wand))
        end,

        --has next
        has_next = function(self)
            return lib.MagickHasNextImage(self.wand)
        end,

        --has prev
        has_prev = function(self)
            return lib.MagickHasPreviousImage(self.wand)
        end,

        reset_iterator = function(self)
            lib.MagickResetIterator(self.wand)
        end,

        --append
        append = function(self, stack)
            if not stack then
                stack = false
            end

            local w = lib.MagickAppendImages(self.wand, stack)

            if tonumber(ffi.cast("intptr_t", w)) ~= 0 then
                return Image(w, "<Append>")
            end
            local code, msg = get_exception(self.wand)

            return nil, code, msg
        end,

        --montage
        montage = function(self, draw, tile_geometry, thumbnail_geometry, mode, frame)
            local mode = mode
            if not mode then
                mode = lib.UnframeMode
            end

            local m = lib.MagickMontageImage(self.wand, draw.wand, tile_geometry, thumbnail_geometry, mode, frame)
            if tonumber(ffi.cast("intptr_t", m)) ~= 0 then
                return Image(m, "<Montage>")
            end

            local code, msg = get_exception(self.wand)

            return nil, code, msg
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

--load new image
local new_image
new_image = function(cols, rows, color)
    local wand = lib.NewMagickWand()
    local path
    
    if not color then
        color = "None"
    end
    
    path = "xc:" .. color

    if 0 == lib.MagickSetSize(wand, cols, rows) then
        local code, msg = get_exception(wand)
        lib.DestroyMagickWand(wand)
        return nil, join_str("set size error.", msg), code
    end

    if 0 == lib.MagickReadImage(wand, path) then
        local code, msg = get_exception(wand)
        lib.DestroyMagickWand(wand)
        return nil, join_str("read image error.", msg), code
    end

    return Image(wand, "<new_image>")
end

return {
    load_image = load_image,
    load_image_from_blob = load_image_from_blob,
    new_image = new_image,
    is_geometry = is_geometry,
    get_geometry = get_geometry,
    Image = Image,
    Draw = Draw
}
