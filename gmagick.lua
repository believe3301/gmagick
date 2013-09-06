local ffi = require("ffi")
ffi.cdef([[  typedef void MagickWand;

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

    //read
    MagickBooleanType MagickReadImage(MagickWand*, const char*);
    MagickBooleanType MagickReadImageBlob(MagickWand*, const void*, const size_t);
  
    int MagickGetImageWidth(MagickWand*);
    int MagickGetImageHeight(MagickWand*);
  
    MagickBooleanType MagickAddImage(MagickWand*, const MagickWand*);
  
    MagickBooleanType MagickAdaptiveResizeImage(MagickWand*, const size_t, const size_t);
  
    //write
    MagickBooleanType MagickWriteImage(MagickWand*, const char*);
    unsigned char* MagickWriteImageBlob(MagickWand*, size_t*);
  
    //Crop
    MagickBooleanType MagickCropImage(MagickWand*,
      const size_t, const size_t, const ssize_t, const ssize_t);

    //Blur
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

    //geometry
    int GetMagickGeometry(const char *geometry,long *x,long *y,unsigned long *width, unsigned long *height);
    int GetGeometry(const char *geometry,long *x,long *y,unsigned long *width, unsigned long *height);
    
  
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
  ["UndefinedCompositeOp"] = 0,
  ["NoCompositeOp"] = 1,
  ["ModulusAddCompositeOp"] = 2,
  ["AtopCompositeOp"] = 3,
  ["BlendCompositeOp"] = 4,
  ["BumpmapCompositeOp"] = 5,
  ["ChangeMaskCompositeOp"] = 6,
  ["ClearCompositeOp"] = 7,
  ["ColorBurnCompositeOp"] = 8,
  ["ColorDodgeCompositeOp"] = 9,
  ["ColorizeCompositeOp"] = 10,
  ["CopyBlackCompositeOp"] = 11,
  ["CopyBlueCompositeOp"] = 12,
  ["CopyCompositeOp"] = 13,
  ["CopyCyanCompositeOp"] = 14,
  ["CopyGreenCompositeOp"] = 15,
  ["CopyMagentaCompositeOp"] = 16,
  ["CopyOpacityCompositeOp"] = 17,
  ["CopyRedCompositeOp"] = 18,
  ["CopyYellowCompositeOp"] = 19,
  ["DarkenCompositeOp"] = 20,
  ["DstAtopCompositeOp"] = 21,
  ["DstCompositeOp"] = 22,
  ["DstInCompositeOp"] = 23,
  ["DstOutCompositeOp"] = 24,
  ["DstOverCompositeOp"] = 25,
  ["DifferenceCompositeOp"] = 26,
  ["DisplaceCompositeOp"] = 27,
  ["DissolveCompositeOp"] = 28,
  ["ExclusionCompositeOp"] = 29,
  ["HardLightCompositeOp"] = 30,
  ["HueCompositeOp"] = 31,
  ["InCompositeOp"] = 32,
  ["LightenCompositeOp"] = 33,
  ["LinearLightCompositeOp"] = 34,
  ["LuminizeCompositeOp"] = 35,
  ["MinusDstCompositeOp"] = 36,
  ["ModulateCompositeOp"] = 37,
  ["MultiplyCompositeOp"] = 38,
  ["OutCompositeOp"] = 39,
  ["OverCompositeOp"] = 40,
  ["OverlayCompositeOp"] = 41,
  ["PlusCompositeOp"] = 42,
  ["ReplaceCompositeOp"] = 43,
  ["SaturateCompositeOp"] = 44,
  ["ScreenCompositeOp"] = 45,
  ["SoftLightCompositeOp"] = 46,
  ["SrcAtopCompositeOp"] = 47,
  ["SrcCompositeOp"] = 48,
  ["SrcInCompositeOp"] = 49,
  ["SrcOutCompositeOp"] = 50,
  ["SrcOverCompositeOp"] = 51,
  ["ModulusSubtractCompositeOp"] = 52,
  ["ThresholdCompositeOp"] = 53,
  ["XorCompositeOp"] = 54,
  ["DivideDstCompositeOp"] = 55,
  ["DistortCompositeOp"] = 56,
  ["BlurCompositeOp"] = 57,
  ["PegtopLightCompositeOp"] = 58,
  ["VividLightCompositeOp"] = 59,
  ["PinLightCompositeOp"] = 60,
  ["LinearDodgeCompositeOp"] = 61,
  ["LinearBurnCompositeOp"] = 62,
  ["MathematicsCompositeOp"] = 63,
  ["DivideSrcCompositeOp"] = 64,
  ["MinusSrcCompositeOp"] = 65,
  ["DarkenIntensityCompositeOp"] = 66,
  ["LightenIntensityCompositeOp"] = 67
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
          local g = get_image_position(self:get_width(), self:get_height(), geometry, self.gravity)
          return g.w, g.h, g.x, g.y
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

      write = function(self, fname)
          return handle_result(self, lib.MagickWriteImage(self.wand, fname))
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
          self.wand, self.path , self.gravity = wand, path, nil
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
    thumb = thumb,
    Image = Image
}
