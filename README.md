# TodoAppProject

The TodoApp is a tool designed to help users efficiently organize their tasks and manage their time effectively. It's a simple app that works as an replacement for the physical todo list.



https://github.com/pandajakob/TodoAppProject/assets/143381764/d841bce9-8f5d-47c1-a4c3-3d16181b252a





## Features
* **add tasks to one or multiple dates**
    
    add the tasks by giving the task a name and picking one or multiple due dates.

* **repeat tasks (<20 years ahead)**

    repeat a task every day, week or month, and tasks will be added for the next 20 years.
    
* **task completion tracking**

    complete tasks with a simple touch

* **flexible filtering**

    filter tasks by completion
    
* **Intuitive User Interface**
    
    The design is very user-friendly and easy to use, with intuitive navigation and clear visual indicators for better usability.    

* **Data Persistence**

    Utilizes CoreData to ensure data persistence across app sessions.
    
## ideas for improvement
* **Error Handling**

    The app doesn't handle possible errors very well, as the form validation is mostly front-end, and there are no unit tests.

* **Cloud Synchronization**

    The app is currently offline-only. However, it could be enhanced by integrating cloud services to synchronize data across devices.

* **Displaying More Tasks**

    Currently, the app only displays tasks up to 100 days ahead. This could potentially be improved by implementing an 'infinite scroll' feature, allowing users to scroll through tasks indefinitely. Additionally, tasks could be repeating for a longer time span, with the current limit set to 20 years.



