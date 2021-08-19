## Schema

Following is a rudimentary image of the designed schema (also present in ```/assets/Schema.jpg```).

<img src="https://i.imgur.com/J8bbM7J.jpg" alt="Schema.jpg" width="700"/>

(Here's a link to the constantly updating version of the same: https://docs.google.com/drawings/d/1iAEuxUk5OZGAiar71Z2P7BNr40fi0QpcwQTIN3S6sFo/edit?usp=sharing)

Following is the code which ultimately performs all the given tasks. All the internals are present in 'main.lua'. Good engineering practices have been somewhat sacrificed in the project in service of speed of prototyping.

```lua
--- ANSWERS

-- 2a
print('2a\n----------------------------------------------------')

Folder.insert{ -- creates a folder named 'AnotherFolder' within '/Folder1/'
  name = '/Folder1/AnotherFolder/'
}

Folder.display() -- display all folders after creation

File.insert{ -- creates a file named 'File5.jpg' in '.../AnotherFolder/'
  path = '/Folder1/AnotherFolder/',
  name = 'File5',
  format = 'jpg',
  size = 4192, -- kbytes,
  dimensions = {
    x = 1024,
    y = 768
  }
}

File.display() -- display all files after creation

-- 2b
print('2b\n----------------------------------------------------')

File.display_reversed_by_date()

-- 2c
print('2c\n----------------------------------------------------')

local folder_path = '/Folder1/'

print(
  string.format('Total size of %s: %d kbytes.\n', 
  folder_path, Folder.total_size_by_path(folder_path)) -- Total folder size
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

```