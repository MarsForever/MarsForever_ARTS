if you want to search the whole filesystem, your command should begin with `find /`.

Two very useful flags are the `-type` and `-name` flags. With `-type`, you can use `d` to only find directories, and `f` to only find files. The `-name` flag is used to specify a name or pattern to look for. 

If you use wildcards, you need to enclose your pattern in quotes, otherwise the command won't work as intended. It is useful to know that you can also use the `-iname` flag; same as `-name`, but case insensitive.



##### Find all files whose name ends with ".xml"

```
find / -type f -name "*.xml"
```



##### Find all files in the /home directory (recursive) whose name is "user.txt" (case insensitive)

```
find /home -type f -iname user.txt
```

##### Find all directories whose name contains the word "exploits"

```
find / -type d -name "*exploits*"
```

