script MyApplescript
    property parent : class "NSObject"
    
    on moveFile___(Origin as string, Destination as string, fileName as string)
        set vb2 to Origin
        set vb4 to Destination
        set vb5 to fileName & ".mp3"
        tell application "Finder"
            set the_files to get every file of folder vb2
            set latestFile to item 1 of (sort the_files by creation date) as alias
            set theDuplicate to duplicate latestFile to vb4
            set name of theDuplicate to vb5
        end tell
    end moveFile___
end script