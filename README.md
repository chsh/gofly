# GoFly - Learning Management System with Google Workspace Integration

[日本語版 / Japanese Version](README_ja.md)

GoFly is a Ruby on Rails learning management system that integrates with Google Workspace services to manage courses, students, and educational content through Google Drive, Sheets, and Forms.

## Features

### Course Management
- Create and manage courses
- Enroll students in courses with enrollment codes
- Track student submissions with file attachments

### Google Workspace Integration
- **Google Drive Files**: Link and download files from Google Drive within courses
- **Google Sheets**: Integrate Google Sheets for data management and form responses
- **Google Forms**: Connect Google Forms and automatically crawl responses from linked Google Sheets
- **Automatic URL Parsing**: Extract Google file IDs from Drive/Docs URLs automatically
- **Service Account Authentication**: Secure API access using Google Service Account credentials

### Student & Submission Management
- Student enrollment and course participation tracking
- File submission system with Active Storage integration
- Form response collection and management

## Technical Stack

- **Framework**: Ruby on Rails 8.0.2
- **Database**: PostgreSQL
- **Frontend**: Hotwire (Turbo + Stimulus), Tailwind CSS
- **Google APIs**: Drive v3, Sheets v4
- **Testing**: RSpec, Factory Bot, Capybara
- **Deployment**: Docker support with Kamal

## Prerequisites

- Ruby 3.x
- PostgreSQL
- Node.js (for asset compilation)
- Google Service Account with Drive and Sheets API access

## Setup

### 1. Clone and Install Dependencies

```bash
git clone <repository-url>
cd gofly
bundle install
```

### 2. Database Setup

```bash
rails db:create
rails db:migrate
```

### 3. Google Service Account Configuration

1. Create a Google Service Account in Google Cloud Console
2. Enable Google Drive API and Google Sheets API
3. Download the service account JSON key file
4. Set the environment variable:

```bash
export GOOGLE_SERVICE_ACCOUNT_CREDENTIAL_PATH=path/to/your/service-account-key.json
```

### 4. Environment Variables

Create a `.env` file with:

```bash
GOOGLE_SERVICE_ACCOUNT_CREDENTIAL_PATH=config/google-service-account.json
DATABASE_URL=postgresql://username:password@localhost/gofly_development
```

### 5. Start the Application

```bash
# Development with Foreman
bin/dev

# Or standard Rails server
rails server
```

## Usage

### Course Management
1. Create courses through the web interface
2. Add Google Files, Sheets, and Forms by providing Google URLs
3. Enroll students using enrollment codes

### Google Integration
- **Files**: Paste Google Drive URLs to link files for download
- **Sheets**: Connect Google Sheets for data management
- **Forms**: Link Google Forms and automatically import responses from connected Google Sheets

### Student Workflow
1. Students enroll in courses using provided codes
2. Submit assignments through the submission system
3. Access course materials and Google resources

## API Structure

### Models
- `Course`: Main course entity with Google resource associations
- `Student`: Student management with course enrollment
- `CourseStudent`: Join table for course enrollment with codes
- `GoogleFile`: Google Drive file integration with download capability
- `GoogleSheet`: Google Sheets integration with form response tracking
- `GoogleForm`: Google Forms with automatic response crawling
- `Submission`: Student file submissions with Active Storage

### Services
- `GoogleService::Connection`: Core Google API client with authentication
- `GoogleService::File`, `GoogleService::Sheet`, `GoogleService::Folder`: Resource-specific handlers
- `GoogleConnectionable`: Shared concern for Google resource models

## Testing

```bash
# Run all tests
bundle exec rspec

# Run specific test files
bundle exec rspec spec/models/
bundle exec rspec spec/requests/
```

## Deployment

The application includes Docker support and Kamal configuration for deployment:

```bash
# Build and deploy with Kamal
kamal deploy
```

## Development

### Key Directories
- `app/models/concerns/google_connectionable.rb`: Shared Google integration logic
- `lib/google_service/`: Google API service classes
- `app/controllers/`: RESTful controllers for all resources
- `spec/`: RSpec test suite with factories

### Adding New Google Resources
1. Create a new model including `GoogleConnectionable`
2. Add appropriate associations to `Course`
3. Implement resource-specific methods in `lib/google_service/`

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

学生番号：2421310006 が追加
