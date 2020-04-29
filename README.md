# GitHub Users API
This project aims to fullfill all T-Mobile coding assigment.

This app is built based on the following criteria:  

## Criteria: 
- Built on MVVM architectureal pattern.
- Is able to search through GitHub users and their corresponding projects using the GitHub api: [https://developer.github.com/v3/]() using Swift. 
- The application shall contain 2 screens: 
	1. The first scene: 
		- will contain a search bar that can search through any user on the GitHub website at the top with a list of results underneath. 
		- Each table cell item should contain the avatar image, username, and the number of repositories they have. 
		- The list view shall not be paginated. Additionally, the search will automatically update upon each letter entered.
		- Tapping on a user will bring up a screen that contains the profile details of that user, aka displaying the second view.
	
	2. The second scene: 
		- The view should contain their avatar image, username, number of followers, number of following, biography, email, location, join date, and a list of public repositories with a search bar at the top. 
		- Each item of the list view shall contain the name of the repository, the number of stars, and the number of forks. 
		- The search bar will allow the user to search through the user’s repository. 
		- The list view shall not be paginated. Additionally, the search will automatically update upon each letter entered.
		- Tapping on a repository shall bring the user to a web browser and open the repository in the GitHub website.

		
		<img align="center" src="Screenshots/Blueprint.png" width="600" height="600" title="Blueprint">
