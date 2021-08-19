local u = require('utility')

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

-- API

-- [ SEEMS OK ]
function Folder._new_id()
  return #Folder + 1
end

-- [ SEEMS OK ]
function File._new_id()
  return #File + 1
end

-- [ SEEMS OK ]
function Folder.retrieve_from_path(path)
  for _, folder in ipairs(Folder) do
    if folder.name == path then
      return folder
    end
  end
  return nil
end

-- [ SEEMS OK ]
function Folder.retrieve_from_id(id)
  for _, folder in ipairs(Folder) do
    if folder._id == id then
      return folder
    end
  end
  return nil
end

-- [ SEEMS OK ]
function File.retrieve_from_id(id)
  for _, file in ipairs(File) do
    if file._id == id then
      return file
    end
  end
end

function Folder._verify(folder)
  -- assuming all required information is provided and in correct format
end

function File._verify(file)
  -- assuming all required information is provided and in correct format
end

-- [ SEEMS OK ]
function Folder._insert_file_id(path, id)
  local folder = Folder.retrieve_from_path(path)
  table.insert(folder.files, id)
end

-- [ SEEMS OK ]
function Folder.insert(folder)
  Folder._verify(folder)

  local to_insert = {
    _id = Folder._new_id(),
    _created = os.time(),
    name = folder.name,
    files = {}
  }

  table.insert(Folder, to_insert)

  return to_insert
end

-- [ SEEMS OK ]
function File.insert(file)
  File._verify(file)

  local to_insert = {
    _id = File._new_id(),
    name = file.name,
    _created = os.time(),
    format = file.format,
    size = file.size,
    folder = Folder.retrieve_from_path(file.path)._id,
    dimensions = file.dimensions and {
      x = file.dimensions.x,
      y = file.dimensions.y
    } or nil
  }

  Folder._insert_file_id(file.path, to_insert._id)

  table.insert(File, to_insert)

  return to_insert
end

-- [ SEEMS OK ]
function File.display_reversed_by_date()
  local items = {}
  for i, item in ipairs(File) do
    items[i] = item
  end

  table.sort(items, function(a, b) return a._created > b._created end)

  File.display('Reversed File Collection', items)
end

-- [ SEEMS OK ]
function File.delete_by_id(id)
  for i, file in ipairs(File) do
    if file._id == id then
      table.remove(File, i)
      return
    end
  end
end

-- [ SEEMS OK ]
local function delete_by_path(folder_path)
  local i, item, subfolder_name
  i = 1
  while i <= #Folder do
    item = Folder[i]
    if string.find(item.name, string.format('^%s', folder_path)) then
      subfolder_name = string.gsub(item.name, string.format('^%s', folder_path), '')
      if subfolder_name ~= '' then
        delete_by_path(item.name)
      else
        i = i + 1
      end
    else
      i = i + 1
    end
  end

  local folder = Folder.retrieve_from_path(folder_path)
  for _, file_id in ipairs(folder.files) do
    File.delete_by_id(file_id)
  end

  for i, folder in ipairs(Folder) do
    if folder.name == folder_path then
      table.remove(Folder, i)
      return
    end
  end
end
Folder.delete_by_path = delete_by_path

-- [ SEEMS OK ]
local function rename(folder_path, new_full_name)
  local subfolder_name
  for _, folder in ipairs(Folder) do
    if string.find(folder.name, string.format('^%s', folder_path)) then
      subfolder_name = string.gsub(folder.name, string.format('^%s', folder_path), '')
      folder.name = new_full_name .. subfolder_name
    end
  end
end
Folder.rename = rename

-- [ SEEMS OK ]
function File.search(name)
  local results = {}

  for _, file in ipairs(File) do
    if u.subset_case_insensitive(name, string.format('%s.%s', file.name, file.format)) then
      table.insert(results, file)
    end
  end

  return results
end

-- [ SEEMS OK ]
function Folder.total_size_by_path(path)
  local folder = Folder.retrieve_from_path(path)
  local file
  local size = 0

  for _, file_id in ipairs(folder.files) do
    file = File.retrieve_from_id(file_id)
    size = size + file.size
  end

  return size
end

-- [ SEEMS OK ]
function File.display(name, collection)
  print(string.format('%s:\n---------------', name or 'File Collection'))
  for i, item in ipairs(collection or File) do
    print(i, item.name, string.format('(%s%s.%s)', Folder.retrieve_from_id(item.folder).name, item.name, item.format))
  end

  print()
end

-- [ SEEMS OK ]
function Folder.display_details_for_path(path)
  local folder = Folder.retrieve_from_path(path)
  local file
  print(string.format('%s (%s):\n---------------', 'Folder Details', folder.name))

  for i, file_id in ipairs(folder.files) do
    file = File.retrieve_from_id(file_id)
    print(string.format('%d\t%s.%s\t%d kbytes', i, file.name, file.format, file.size))
  end

  if #folder.files == 0 then
    print('(no files in this folder.)')
  end

  print()
end

-- [ SEEMS OK ]
function Folder.display(name, collection)
  print(string.format('%s:\n---------------', name or 'Folder Collection'))
  
  for i, item in ipairs(collection or Folder) do
    print(i, item.name)
  end

  print()
end

--- ANSWERS

-- 2a
print('2a\n----------------------------------------------------')

Folder.insert{
  name = '/Folder1/AnotherFolder/'
}

Folder.display()

File.insert{
  path = '/Folder1/AnotherFolder/',
  name = 'File5',
  format = 'jpg',
  size = 4192, -- kbytes,
  dimensions = {
    x = 1024,
    y = 768
  }
}

File.display()

-- 2b
print('2b\n----------------------------------------------------')

File.display_reversed_by_date()

-- 2c
print('2c\n----------------------------------------------------')

local folder_path = '/Folder1/'

print(
  string.format('Total size of %s: %d kbytes.\n', 
  folder_path, Folder.total_size_by_path(folder_path))
)
Folder.display_details_for_path(folder_path)

-- 2d
print('2d\n----------------------------------------------------')

Folder.delete_by_path(folder_path)
Folder.display()
File.display()

-- 2e & 2f
print('2e & 2f\n----------------------------------------------------')

File.display('Search results', File.search('File3'))
File.display('Search results', File.search('File3.jpg'))

-- 2g
print('2g\n----------------------------------------------------')

Folder.rename('/Folder2/SubFolder2/', '/Folder2/NestedFolder2/')

Folder.display()
File.display()