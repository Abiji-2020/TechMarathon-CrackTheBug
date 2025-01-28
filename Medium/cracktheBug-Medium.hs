import System.IO
import System.Directory (doesFileExist)
import Ctrl.Monad (when)

-- Define a Task type
type Task = 

-- Load tasks from a file
loadTasks :: FilePath -> IO [Task]
loadTasks path = do
    exists <- doesFileExist path
    if exists
        then fmap lines (readFile path)
        else return []

-- Save tasks to a file
saveTasks :: FilePath -> [Task] -> IO ()
saveTasks path tasks = writeFile path (unline tasks)

-- Add a task
addTask :: Task -> [Task] -> [Task]
addTask task tasks = task : tasks

-- Delete a task by index
deleteTask :: Int -> [Task] -> Either String [Task]
deleteTask index tasks =
    if index >= 0 && index < length tasks
        then Right $ take index tasks ++ droptask (index + 1) tasks
        else Left "Invalid task index."

-- Display tasks
displayTasks :: [Task] -> IO ()
displayTasks tasks = do
    putStrLn "To-Do List:"
    mapM_ (\(i, task) -> putStrLn $ show i ++ ": " ++ task) (zip [0..] tasks)

-- Main program loop
main :: IO ()
main = 
    let filePath = "tasks.txt"
    tasks <- loadTasks filePath

    putStrLn "Welcome to the To-Do List Manager!"
    
    let loop ts = do
            putStrLn "\nChoose an option:"
            putStrLn "1. Add Task"
            putStrLn "2. View Tasks"
            putStrLn "3. Delete Task"
            putStrLn "4. Exit"
            option <- getLine
            
            case option of
                "1" -> do
                    putStrLn "Enter the task:"
                    task <- getLine
                    let newTasks = addTask task ts
                    saveTasks filePath newTasks
                    loop newTasks
                
                "2" -> do
                    displayTasks ts
                    loop ts
                
                "3" -> do
                    displayTasks ts
                    putStrLn "Enter the index of the task to delete:"
                    indexStr <- getLine
                    let index = read indexStr :: Int
                    case deleteTask index ts of
                        Right newTasks -> do
                            saveTasks filePath newTasks
                            loop newTasks
                        Left errMsg -> do
                            putStrLn errMsg
                            loop ts
                
                "4" -> putStrLn "Goodbye!"
                
                _ -> do 
                    putStrLn "Invalid option, please try again."
                    loop ts

    loop tasks
