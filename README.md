# Help Match

**Help Match** is a platform that connects volunteers with organizations offering volunteering opportunities. It allows volunteers to explore, search, and apply for jobs, while organizations can manage and approve candidates. Once approved, a chat room is automatically created for seamless communication between the volunteer and the organization's account manager. The platform also plans to issue PDF certificates upon completion of volunteering tasks (feature in progress).

---

## Features

### For Volunteers:
- **Explore Opportunities**: Browse through a list of volunteering opportunities posted by organizations.
- **Search and Pagination**: Easily search for opportunities and navigate through results with pagination.
- **Apply for Jobs**: Apply for volunteering positions with a single click.
- **Certificates**: Receive a PDF certificate upon completion of a volunteering task (in progress).

### For Organizations:
- **Post Opportunities**: Create and manage volunteering job postings.
- **Approve Candidates**: Review and approve volunteer applications.
- **Chat Room**: Automatically create and join a chat room with approved candidates for seamless communication.

### General:
- **JWT Authentication**: Secured with JSON Web Tokens (JWT) for secure user authentication.
- **Caching**: Uses Redis (soon) for caching to improve performance.
- **Responsive UI**: Frontend built with Flutter, with ongoing improvements to make the UI more intuitive and visually appealing.

---

## Technologies Used

### Backend:
- **Programming Language**: Go (Golang)
- **Database**: PostgreSQL
- **Caching**: Redis (soon)
- **Authentication**: JWT (JSON Web Tokens)

### Frontend:
- **Framework**: Flutter
- **State Management**: BloC
- **UI/UX**: Ongoing improvements for a modern and user-friendly interface.



## Future Features
- **PDF Certificate Generation**: Automatically generate and issue PDF certificates upon task completion.
- **Redis Caching**: Implement Redis for caching to improve performance.
- **Real-Time Notifications**: Notify users of new messages, approvals, or opportunities.
- **Admin Dashboard**: A dashboard for admins to manage users, organizations, and opportunities.

