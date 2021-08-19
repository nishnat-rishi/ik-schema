-- This contains just the data part of the project. The data-structure used to 
-- store the data very closely resembles the BSON format utilized by MongoDb.

local Folder = {
  {
    _id = 1,
    _created = os.time(),
    name = '/',
    files = {}
  },
  {
    _id = 2, -- u_int_32
    _created = os.time() - 8,
    name = '/Folder1/', -- string / full name of the file along with the path
    files = { -- u_int_32[]
      1,
      2
    }
  },
  {
    _id = 3,
    _created = os.time() - 7,
    name = '/Folder2/',
    files = {}
  },
  {
    _id = 4,
    _created = os.time() - 6,
    name = '/Folder2/SubFolder1/',
    files = {}
  },
  {
    _id = 5,
    _created = os.time() - 5,
    name = '/Folder2/SubFolder2/',
    files = {
      3,
      4
    }
  }
}

local File = {
  {
    _id = 1,
    _created = os.time() - 4,
    name = 'File1', -- string
    folder = 2, -- id / object reference (4 bytes)
    format = 'png', -- string
    size = 16384, -- size in kb / u_int_32 / 4 bytes / (upto 4Tb)
    dimensions = {
      x = 1280, -- size in pixels / u_int_16 / 2 bytes / (upto 64k)
      y = 720 -- size in pixels / u_int_16 / 2 bytes / (upto 64k)
    }
  },
  {
    _id = 2,
    _created = os.time() - 3,
    name = 'File2',
    folder = 2,

    format = 'png',
    size = 12198,
    dimensions = {
      x = 1920,
      y = 1080
    }
  },
  {
    _id = 3,
    _created = os.time() - 2,
    name = 'File3',
    folder = 5,

    format = 'jpg',
    size = 4198,
    dimensions = {
      x = 640,
      y = 800
    }
  },
  {
    _id = 4,
    _created = os.time() - 1,
    name = 'File4',
    folder = 5,

    format = 'txt',
    size = 25, -- kbytes
  },
}