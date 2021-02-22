****Coding Challenge****

  

![](demo.gif)

  

This project has the following requirements:

  

1. This code test must be written in Swift 4 or later.

2. The deployment target must be iOS 11+

3. The application must download and parse the JSON found at this URL: http://jsonplaceholder.typicode.com/photos

4. Display the images found at the thumbnailUrl key for each node in the JSON, in either a UITableView or UICollectionView.

5. When tapped, display the image found at the url key in a detail view for each item in the UITableView or UICollectionView.

6. Include Unit Tests.

7. Add the ability for the user to pull to refresh your initial list view.

  

****Considerations****

  

1. This Project uses an architecture called clean swift: https://clean-swift.com

2. All the internet connections are handled using URLSession

3. The exercise is localized, (English only for the moment)

4. For the image downloads I turned  `Allow arbitrary loads`  instead of whitelisting domains because I don’t know where those images will be coming from. I’m not an expert about the API the exercise is using it and it exceeds the scope of this exercise.

5. In the case a download task started and for some reason the resource is not necessary the code has the ability to cancel it, all of this is handled in the class: CustomImageViewWithCache.swift

6. When the user executes the pull down to refresh and for some reason it fails, the application will clean the previous content and it will show a message informing to the user what is happening

7. The application works on iPhone and Ipad, both orientations(landscape and portrait)

8. The application has error handle

9. The application uses pagination to get the data from the API

10. The application uses cache to storage each image, this means If a new request is executed and the image was stored there, the app will not execute a new download

****Improvements to do****

 1. Replace the table view per a collection view, this will allow to show the images in a better way in the different devices
