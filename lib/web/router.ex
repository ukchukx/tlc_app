defmodule TlcApp.Web.Router do
  use TlcApp.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug TlcApp.Web.Plug.LoadAuthUser
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", TlcApp.Web do
    pipe_through :browser

    get "/", PageController, :index

    get "/signin", SessionController, :signin
    post "/signin", SessionController, :create_session
    get "/signout", SessionController, :delete_session

    get "/bo", PageController, :bo_index

    resources "/bo/courses", CourseController, only: [:index, :create, :update, :delete, :show]
    post "/bo/courses/:id/schedules", CourseController, :create_schedules
    delete "/bo/schedules/:id", CourseController, :delete_schedule


    post "/sign-attendance", PageController, :sign_attendance

    resources "/users", UserController, only: [:edit, :update]

    get "/bo/attendances/download", AttendanceController, :download

    resources "/bo/users", UserController
    post "/bo/users/upload-students", UserController, :upload_students
    post "/bo/users/register-course", UserController, :add_course_reg
    delete "/bo/users/unregister-course/:id", UserController, :delete_course_reg

    resources "/bo/time-tables", TimetableController

    get "/bo/settings", SettingController, :index

    get "/*path", PageController, :catch_all
  end

  # Other scopes may use custom stacks.
  # scope "/api", TlcApp.Web do
  #   pipe_through :api
  # end
end
