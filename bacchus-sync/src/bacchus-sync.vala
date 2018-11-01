using Gtk;

/**
 * enum Status
 */
enum Status {
  GUEST,        /* guest: waiting for user's response */
  CHECKING,     /* domain: checking out */
  CONFLICT,     /* domain: resolving conflict */
}

/**
 * enum Objective
 */
enum Objective {
  LOGIN,
  LOGOUT,
}

/**
 * enum UserType
 */
enum UserType {
  DOMAIN,       /* A CSE domain user */
  GUEST,        /* A domain with transient home directory */
}

/**
 * enum Language
 */
enum Language {
  EN,           /* English */
  KO,           /* Korean */
}

/**
 * enum Action
 */
enum Action {
  LOGOUT,       /* cancel the progress and logout */
  FORCE_CHECKOUT, /* force checkout, ignore synchronization issue */
  FORCE_LOGIN,  /* force login into this host */
  TRANSIENT,    /* login into transient home directory */
}

/*
 * enum Wording
 */
enum Wording {
  NULL,         /* Empty string */
  WINDOW_TITLE, /* Window title */
  PLEASE_WAIT,
  CANNOT_TRACK, /* Cannot track the progress */
  OK,
  PS1,

  /* Guest user */
  GUEST_TITLE,
  GUEST_MESSAGE,

  /* Domain user: home directory conflict */
  CONFLICT_TITLE,
  CONFLICT_MESSAGE,
  CONFLICT_ISSUED,  /* Issued remote logout command */

  /* Domain user: downloading */
  CHECKING_TITLE,
  CHECKING_MESSAGE,
  CHECKING_STARTED, /* Started checking out */
  CHECKING_ERROR,
}

/**
 * enum StringKey
 */
enum StringKey {
  COMPLETE,   /* lockfile meaning local copy of home directory is complete */
  SESSION,    /* file indicates that session for the user exists */
  CHECKOUT,   /* file indicates that home directory of the user is checked out */
  LOGOUT,     /* file indicates logout command */
  HOSTNAME,   /* /etc/hostname */
  RSYNC,      /* /usr/bin/rsync */
  RSYNC_AZ,
  RSYNC_DELETE,
  RSYNC_PROGRESS2,
  NFS_HOME,
  NFS_HOME_OF,
  LOCAL_HOME,
  LOCAL_HOME_OF,
  RSYNC_WATCHER,    /* thread: watch download progress */
  REMOTE_WATCHER,   /* thread: watch upload progress on remote PC */
  RSYNC_ECHO,
  USER,       /* Environment variable key */
  READ,
  WRITE,
  RSYNC_EXCLUDE,
}

/**
 * class Configuration
 * Static configurations
 */
class Configuration {
  /* exit status */
  public static const int EXIT_NORMAL = 0;
  public static const int EXIT_ERROR = 1;
  public static const int EXIT_LOGOUT = 2;
  public static const int EXIT_TRANSIENT = 3;

  /* wait period */
  public static const int UPDATE_MILLISEC = 500;
  public static const int ECHO_MICROSEC = 2000000;
  public static const int SLEEP_MICROSEC = 500000;

  /* GUI */
  public static const int WIDTH = 700;
  public static const int HEIGHT = 450;
  public static const int SPACING = 10;

  public static Language[] languages() {
    return {Language.EN, Language.KO};
  }

  /* Command Line Options for UserType */
  public static UserType? option2UserType(string option) {
    switch (option) {
      case "--domain":
        return UserType.DOMAIN;
      case "--guest":
        return UserType.GUEST;
      default:
        return null;
    }
  }

  /* Command Line Options for Objective */
  public static Objective? option2Objective(string option) {
    switch (option) {
      case "--login":
        return Objective.LOGIN;
      case "--logout":
        return Objective.LOGOUT;
      default:
        return null;
    }
  }

  /* names */
  public static string stringKey(StringKey stringKey) {
    switch (stringKey) {
      case StringKey.COMPLETE:
        return "/csehome/.sync-status/%s/complete";
      case StringKey.SESSION:
        return "/csehome/.sync-status/%s/session";
      case StringKey.CHECKOUT:
        return "/sherry/.sync-status/%s/checkout";
      case StringKey.LOGOUT:
        return "/sherry/.sync-status/%s/logout";
      case StringKey.HOSTNAME:
        return "/etc/hostname";
      case StringKey.RSYNC:
        return "/usr/bin/rsync";
      case StringKey.RSYNC_AZ:
        return "-az";
      case StringKey.RSYNC_DELETE:
        return "--delete";
      case StringKey.RSYNC_PROGRESS2:
        return "--info=progress2";
      case StringKey.NFS_HOME:
        return "/sherry";
      case StringKey.NFS_HOME_OF:
        return "/sherry/%s";
      case StringKey.LOCAL_HOME:
        return "/csehome";
      case StringKey.LOCAL_HOME_OF:
        return "/csehome/%s";
      case StringKey.RSYNC_WATCHER:
        return "rsync-watcher";
      case StringKey.REMOTE_WATCHER:
        return "remote-watcher";
      case StringKey.RSYNC_ECHO:
        return "rsync-echo";
      case StringKey.USER:
        return "USER";
      case StringKey.READ:
        return "r";
      case StringKey.WRITE:
        return "w";
      case StringKey.RSYNC_EXCLUDE:
		return "--exclude=.cache/"
      default:
        fatal("Unknown StringKey");
        return "";
    }
  }
}

/**
 * class Translation
 */
class Translation {
  public static string userType(Language lang, UserType userType) {
    switch (lang) {
      case Language.KO:
        switch (userType) {
          case UserType.DOMAIN:
            return "도메인 사용자";
          case UserType.GUEST:
            return "손님";
          default:
            fatal("Unknown UserType for KO");
            break;
        }
        break;
      case Language.EN:
        switch (userType) {
          case UserType.DOMAIN:
            return "Domain user";
          case UserType.GUEST:
            return "Guest";
          default:
            fatal("Unknown UserType for EN");
            break;
        }
        break;
      default:
        fatal("Unknown language for UserType");
        break;
    }
    return "";
  }

  public static string language(Language lang) {
    switch (lang) {
      case Language.KO:
        return "한국어";
      case Language.EN:
        return "English";
      default:
        fatal("Unknown language");
        break;
    }
    return "";
  }

  public static string action(Language lang, Action action) {
    switch (lang) {
      case Language.KO:
        switch (action) {
          case Action.LOGOUT:
            return "그만두고 로그인 화면으로 돌아가기";
          case Action.FORCE_CHECKOUT:
            return "문제를 무시하고 다운로드 시작 (파일을 일부 잃을 수 있습니다!)";
          case Action.FORCE_LOGIN:
            return "강제로 이 PC에 로그인 (파일을 일부 잃을 수 있습니다!)";
          case Action.TRANSIENT:
              return "임시 홈 디렉토리로 로그인";
          default:
            fatal("Unknwon Action for KO");
            break;
        }
        break;
      case Language.EN:
        switch (action) {
          case Action.LOGOUT:
            return "Quit and return to the login menu";
          case Action.FORCE_CHECKOUT:
            return "Ignore this problem and start downloading (You might lose some of your files!)";
          case Action.FORCE_LOGIN:
            return "Force logging in to this PC (You might lose some of your files!)";
          case Action.TRANSIENT:
            return "Log in with temporary home directory";
          default:
            fatal("Unknwon Action for EN");
            break;
        }
        break;
      default:
        fatal("Unknown language for Action");
        break;
    }
    return "";
  }

  public static string wording(Language lang, Wording wording) {
    switch (lang) {
      case Language.KO:
        switch (wording) {
          case Wording.NULL:
            return "";
          case Wording.WINDOW_TITLE:
            return "홈 디렉토리 동기화 서비스";
          case Wording.PLEASE_WAIT:
            return "기다려 주십시오...";
          case Wording.CANNOT_TRACK:
            return "진행상황을 추적할 수 없습니다.";
          case Wording.OK:
            return "확인";
          case Wording.PS1:
            return "<i>%s @ %s</i>";
          case Wording.GUEST_TITLE:
            return "손님은 임시 홈 디렉토리로 로그인합니다";
          case Wording.GUEST_MESSAGE:
            return "손님 계정입니다. 로그아웃시 홈 디렉토리가 지워진다는 점에 주의해주세요. 사용을 마치기 전에 중요한 파일은 안전한 곳에 저장하시기 바랍니다.";
          case Wording.CONFLICT_TITLE:
            return "파일이 아직 완전하게 동기화되지 않았습니다";
          case Wording.CONFLICT_MESSAGE:
            return "%s 번 PC에서 적절하게 로그아웃하지 않았습니다. 이 문제를 자동으로 해결하려고 시도하는 중입니다. 잠시 기다려주시거나, 아래 옵션을 선택해주세요. 아니면 로그인을 취소하고 %s 로 가셔서 로그인하셔도 됩니다.";
          case Wording.CONFLICT_ISSUED:
            return "원격 PC에 요청을 전송했습니다. 반응을 기다리는 중입니다.";
          case Wording.CHECKING_TITLE:
            return "체크아웃 중...";
          case Wording.CHECKING_MESSAGE:
            return "홈 디렉토리를 중앙 서버에서 받는 중입니다. 기다려 주시거나 아래 옵션을 선택해주세요.";
          case Wording.CHECKING_STARTED:
            return "다운로드 시작";
          case Wording.CHECKING_ERROR:
            return "일부 파일이 제대로 동기화되지 않았습니다. 죄송합니다, 아래 옵션 중 하나를 선택해 주십시오. contact@bacchus.snucse.org 로 문제를 보고해주시면 처리해드리겠습니다.";
          default:
            fatal("Unknown Wording for KO");
            break;
        }
        break;
      case Language.EN:
        switch (wording) {
          case Wording.NULL:
            return "";
          case Wording.WINDOW_TITLE:
            return "Home Directory Synchronization Service";
          case Wording.PLEASE_WAIT:
            return "Please wait...";
          case Wording.CANNOT_TRACK:
            return "Cannot track the progress.";
          case Wording.OK:
            return "OK";
          case Wording.PS1:
            return "<i>%s %s @ %s</i>";
          case Wording.GUEST_TITLE:
            return "Guest account with transient home directory";
          case Wording.GUEST_MESSAGE:
            return "This is a guest account. Please be informed that your home directory will be deledted as you log out. Save your files in other storage before leaving this PC.";
          case Wording.CONFLICT_TITLE:
            return "Your files are not synchronized completely";
          case Wording.CONFLICT_MESSAGE:
            return "You were not logged out from %s properly. We\'re trying to solve this issue automatically. Please wait or select one of the options below to continue. You can also cancel this login, go to %s, and try to login there.";
          case Wording.CONFLICT_ISSUED:
            return "Sent our request to the remote PC. Waiting for responses.";
          case Wording.CHECKING_TITLE:
            return "Checking out...";
          case Wording.CHECKING_MESSAGE:
            return "We\'re downloading your home directory from the server. Please wait or select one of the options below to continue.";
          case Wording.CHECKING_STARTED:
            return "Started downloading";
          case Wording.CHECKING_ERROR:
            return "We\'re sorry, but some of your files are not downloaded properly. Please select one of the options below. Report this issue to contact@bacchus.snucse.org and we\'ll help you out.";
          default:
            fatal("Unknown Wording for EN");
            break;
        }
        break;
      default:
        fatal("Unknown language for Wording");
        break;
    }
    return "";
  }
}

/**
 * function fatal
 * print error message and exit
 */
void fatal(string message) {
  stderr.puts(message + "\n");
  Process.exit(Configuration.EXIT_ERROR);
}

/**
 * function warning
 * print error message
 */
void warning(string message) {
  stderr.puts(message + "\n");
}

/**
 * class SingleLineFile
 */
class SingleLineFile : Object {
  private string path;
  private File file;
  private string _content;

  public SingleLineFile(string path) {
    this.path = path;
    file = File.new_for_path(path);
  }

  public void create() {
    try {
      file.create(0);
    } catch (Error e) {
      warning("Cannot create file " + path + ": " + e.message);
    }
  }

  public void delete() throws Error {
    file.delete();
  }

  public string? content {
    public get {
      try {
        _content = new DataInputStream(file.read()).read_line();
        return _content;
      } catch (Error e) {
        return null;
      }
    }
    public set {
      FileStream stream = FileStream.open(path, Configuration.stringKey(StringKey.WRITE));
      stream.puts(value);
    }
  }

  public bool exists {
    public get {
      return file.query_exists();
    }
  }
}

/**
 * class LineFeedStreamWatcher
 */
class LineFeedStreamWatcher : Object {
  public delegate bool OnLine(string line);
  private unowned FileStream fs;
  private unowned OnLine onLine;
  private Thread<bool> thread;
  private bool running;

  public LineFeedStreamWatcher(FileStream fs, OnLine onLine) {
    this.fs = fs;
    this.onLine = onLine;
    thread = null;
    running = false;
  }

  public void start(string threadName) {
    if (running) {
      return;
    }
    running = true;
    thread = new Thread<bool>(threadName, run);
  }

  public void stop() {
    if (!running) {
      return;
    }
    running = false;
    thread.join();
  }

  private bool run() {
    string line = "";
    while (true) {
      if (!running) {
        return false;
      }
      int c = fs.getc();
      if (c == FileStream.EOF) {
        return true;
      }
      if (c == '\r') {
        if (!onLine(line)) {
          return false;
        }
        line = "";
      } else {
        line = line + ((char)c).to_string();
      }
    }
  }
}

/**
 * class PeriodicStatusEcho
 */
class PeriodicStatusEcho : Object {
  private unowned LineFeedStreamWatcher.OnLine onStatus;

  private bool running;
  public string? status;
  private string? _status;

  private Thread<bool> thread;

  public PeriodicStatusEcho(LineFeedStreamWatcher.OnLine onStatus) {
    this.onStatus = onStatus;
    status = _status = null;
    running = false;
  }

  public void start(string threadName) {
    if (running) {
      return;
    }
    running = true;
    thread = new Thread<bool>(threadName, run);
  }

  public void stop() {
    if (!running) {
      return;
    }
    running = false;
    thread.join();
  }

  private bool run() {
    while (true) {
      if (!running) {
        return false;
      }
      if (status != _status) {
        _status = status;
        if (!onStatus(_status)) {
          return false;
        }
      }
      Thread.usleep(Configuration.ECHO_MICROSEC);
    }
  }
}

/**
 * class DownloadTask
 */
class DownloadTask : Object {
  public delegate void OnExit(int exit_status);

  private string userName;
  private unowned LineFeedStreamWatcher.OnLine onLine;
  private unowned OnExit onExit;
  private LineFeedStreamWatcher watcher;
  private FileStream out_fs;
  private Pid? child_pid;

  public DownloadTask(string userName, LineFeedStreamWatcher.OnLine onLine, OnExit onExit) {
    this.userName = userName;
    this.onLine = onLine;
    this.onExit = onExit;
    child_pid = null;
  }

  public void start() {
    if (child_pid != null) {
      return;
    }
    int out_fd;
    try {
      Process.spawn_async_with_pipes(
          null,
          {
            Configuration.stringKey(StringKey.RSYNC),
            Configuration.stringKey(StringKey.RSYNC_AZ),
            Configuration.stringKey(StringKey.RSYNC_DELETE),
            Configuration.stringKey(StringKey.RSYNC_PROGRESS2),
            Configuration.stringKey(StringKey.RSYNC_EXCLUDE),
            Configuration.stringKey(StringKey.NFS_HOME_OF).printf(userName),
            Configuration.stringKey(StringKey.LOCAL_HOME),
          },
          Environ.get(),
          SpawnFlags.DO_NOT_REAP_CHILD,
          null,
          out child_pid,
          null,
          out out_fd,
          null
          );
    } catch (SpawnError e) {
      fatal("Error starting downloading for user " + userName + ": " + e.message);
    }
    ChildWatch.add(child_pid, (pid, status) => {
        watcher.stop();
        Process.close_pid(pid);
        onExit(status);
        });
    out_fs = FileStream.fdopen(out_fd, Configuration.stringKey(StringKey.READ));
    watcher = new LineFeedStreamWatcher(out_fs, onLine);
    watcher.start(Configuration.stringKey(StringKey.RSYNC_WATCHER));
  }

  public void stop() {
    if (child_pid == null) {
      return;
    }
    Posix.kill((Posix.pid_t)child_pid, Posix.SIGTERM);
  }
}

/**
 * class UploadTask
 */
class UploadTask : Object {
  private string userName;
  private unowned LineFeedStreamWatcher.OnLine onLine;
  private unowned DownloadTask.OnExit onExit;
  private LineFeedStreamWatcher watcher;
  private PeriodicStatusEcho echo;
  private FileStream out_fs;
  private Pid? child_pid;

  public UploadTask(string userName, LineFeedStreamWatcher.OnLine onLine, DownloadTask.OnExit onExit) {
    this.userName = userName;
    this.onLine = onLine;
    this.onExit = onExit;
    child_pid = null;
  }

  public void start() {
    if (child_pid != null) {
      return;
    }
    int out_fd;
    try {
      Process.spawn_async_with_pipes(
          null,
          {
            Configuration.stringKey(StringKey.RSYNC),
            Configuration.stringKey(StringKey.RSYNC_AZ),
            Configuration.stringKey(StringKey.RSYNC_DELETE),
            Configuration.stringKey(StringKey.RSYNC_PROGRESS2),
            Configuration.stringKey(StringKey.RSYNC_EXCLUDE),
            Configuration.stringKey(StringKey.LOCAL_HOME_OF).printf(userName),
            Configuration.stringKey(StringKey.NFS_HOME),
          },
          Environ.get(),
          SpawnFlags.DO_NOT_REAP_CHILD,
          null,
          out child_pid,
          null,
          out out_fd,
          null
          );
    } catch (SpawnError e) {
      fatal("Error starting uploading for user " + userName + ": " + e.message);
    }
    ChildWatch.add(child_pid, (pid, status) => {
        echo.stop();
        watcher.stop();
        Process.close_pid(pid);
        onExit(status);
        });
    out_fs = FileStream.fdopen(out_fd, Configuration.stringKey(StringKey.READ));
    echo = new PeriodicStatusEcho(onLine);
    watcher = new LineFeedStreamWatcher(out_fs, (line) => { echo.status = line; return true; });
    watcher.start(Configuration.stringKey(StringKey.REMOTE_WATCHER));
    echo.start(Configuration.stringKey(StringKey.RSYNC_ECHO));
  }

  public void stop() {
    if (child_pid == null) {
      return;
    }
    Posix.kill((Posix.pid_t)child_pid, Posix.SIGTERM);
  }
}

/**
 * class Context
 * Stores current status about user and home directory
 */
class Context : Object {
  public string hostName { get; private set; }
  public string userName { get; private set; }
  public UserType userType { get; private set; }
  public Objective objective { get; private set; }

  public SingleLineFile completeFile {get; private set;}
  public SingleLineFile sessionFile {get; private set;}
  public SingleLineFile checkoutFile {get; private set;}
  public SingleLineFile logoutFile {get; private set;}

  public DownloadTask? downloadTask { get; private set; }
  public string? downloadStatus { get; private set; }
  public int? downloadExit { get; private set; }
  public UploadTask? uploadTask { get; private set; }
  public int? exit_status { get; private set; }

  public Context(string hostName, string userName, UserType userType, Objective objective) {
    this.hostName = hostName;
    this.userName = userName;
    this.userType = userType;
    this.objective = objective;

    completeFile = new SingleLineFile(Configuration.stringKey(StringKey.COMPLETE).printf(userName));
    sessionFile = new SingleLineFile(Configuration.stringKey(StringKey.SESSION).printf(userName));
    checkoutFile = new SingleLineFile(Configuration.stringKey(StringKey.CHECKOUT).printf(userName));
    logoutFile = new SingleLineFile(Configuration.stringKey(StringKey.LOGOUT).printf(userName));

    downloadTask = null;
    downloadStatus = null;
    downloadExit = null;
    uploadTask = null;
    exit_status = null;
  }

  public void init() {
    if (objective == Objective.LOGIN && userType == UserType.DOMAIN) {
      sessionFile.create();
    } else if (objective == Objective.LOGOUT && userType == UserType.DOMAIN) {
      if (checkoutFile.content != hostName || !completeFile.exists) {
        exit_error(Configuration.EXIT_ERROR);
      }
      try {
        sessionFile.delete();
      } catch (Error e) {
      }
      logoutFile.create();
    }
  }

  private void exit_common() {
    if (uploadTask != null) {
      uploadTask.stop();
    }
    if (downloadTask != null) {
      downloadTask.stop();
    }
  }

  public void exit_error(int status) {
    exit_common();
    if (objective == Objective.LOGIN && userType == UserType.DOMAIN) {
      try {
        sessionFile.delete();
      } catch (Error e) {
        warning("Cannot delete session file for user " + userName + ": " + e.message);
      }
      if (checkoutFile.content == hostName) {
        try {
          checkoutFile.delete();
        } catch (Error e) {
        }
      }
    }
    exit_status = status;
  }

  public void exit_normal() {
    exit_common();
    if (objective == Objective.LOGIN && userType == UserType.DOMAIN) {
      try {
        logoutFile.delete();
      } catch (Error e) {
      }
    }
    exit_status = Configuration.EXIT_NORMAL;
  }

  public void upload() {
    if (objective != Objective.LOGOUT || userType != UserType.DOMAIN) {
      fatal("Upload not in <logout, domain>");
    }
    if (uploadTask != null) {
      return;
    }
    uploadTask = new UploadTask(
        userName,
        (line) => {
          if (logoutFile.exists) {
              logoutFile.content = line;
              return true;
            } else {
              exit_error(Configuration.EXIT_ERROR);
              return false;
            }
        },
        (exit_status) => {
          if (!sessionFile.exists && exit_status == Configuration.EXIT_NORMAL) {
            try {
              checkoutFile.delete();
            } catch (Error e) {
            }
          }
          exit_normal();
        });
    uploadTask.start();
  }

  public void download() {
    if (objective != Objective.LOGIN || userType != UserType.DOMAIN) {
      fatal("Download not in <login, domain>");
    }
    if (downloadTask != null) {
      return;
    }
    try {
      completeFile.delete();
    } catch (Error e) {
    }
    downloadTask = new DownloadTask(
        userName,
        (line) => { downloadStatus = line; return true; },
        (exit_status) => {
          if (exit_status == Configuration.EXIT_NORMAL) {
            completeFile.create();
            } else {
              downloadExit = exit_status;
            }
        });
    downloadTask.start();
  }

  public void forceCheckout() {
    if (objective != Objective.LOGIN || userType != UserType.DOMAIN) {
      fatal("forceCheckout not in <login, domain>");
    }
    checkoutFile.content = hostName;
  }

  public void forceLogin() {
    if (objective != Objective.LOGIN || userType != UserType.DOMAIN) {
      fatal("forceLogin not in <login, domain>");
    }
    forceCheckout();
    completeFile.create();
    exit_normal();
  }

  public void issueLogoutCommand() {
    if (objective != Objective.LOGIN || userType != UserType.DOMAIN) {
      fatal("issueLogoutCommand not in <login, domain>");
    }
    logoutFile.create();
  }

  public void act(Action action) {
    switch (action) {
      case Action.LOGOUT:
        exit_error(Configuration.EXIT_LOGOUT);
        break;
      case Action.FORCE_CHECKOUT:
        forceCheckout();
        break;
      case Action.FORCE_LOGIN:
        forceLogin();
        break;
      case Action.TRANSIENT:
        exit_error(Configuration.EXIT_TRANSIENT);
        break;
      default:
        fatal("Unknown Action");
        break;
    }
  }
}

/**
 * class UpdateIteration
 * Initate activity update(redraw) and manage background task
 */
class UpdateIteration : Object {
  private Context context;
  private Activity? activity;

  public UpdateIteration(Context context, Activity? activity) {
    this.context = context;
    this.activity = activity;
  }

  public bool iterate() {
    if (context.exit_status != null) {
      Gtk.main_quit();
      if (mainLoop != null) {
        mainLoop.quit();
      }
      return GLib.Source.REMOVE;
    }
    if (context.objective == Objective.LOGOUT) {
      context.upload();
    } else if (context.userType == UserType.GUEST) {
      activity.renderStatus(Status.GUEST);
    } else if (!context.checkoutFile.exists || context.checkoutFile.content == null) {
      context.checkoutFile.content = context.hostName;
      context.download();
      activity.renderStatus(Status.CHECKING);
    } else if (context.checkoutFile.content != context.hostName) {
      context.issueLogoutCommand();
      activity.renderStatus(Status.CONFLICT);
    } else if (context.completeFile.exists) {
      context.exit_normal();
    } else {
      context.download();
      activity.renderStatus(Status.CHECKING);
    }
    return GLib.Source.CONTINUE;
  }
}

/**
 * class Activity
 * Handles user interaction
 */
class Activity : Object {
  public delegate void Act(Action action);

  private Window window;
  private Context context;
  private unowned Act act;

  private Notebook notebook;
  private Array<Page> pages;

  public Activity(Context context, Act act) {
    this.context = context;
    this.act = act;
  }

  public void init() {
    window = new Window();
    window.title = Translation.wording(Configuration.languages()[0], Wording.WINDOW_TITLE);
    window.border_width = 0;
    window.window_position = WindowPosition.CENTER;
    window.set_default_size(Configuration.WIDTH, Configuration.HEIGHT);
    window.destroy.connect(() => { act(Action.LOGOUT); });
    Box box = new Box(Orientation.VERTICAL, 0);

    notebook = new Notebook();
    notebook.border_width = Configuration.SPACING;
    pages = new Array<Page>();
    foreach (Language lang in Configuration.languages()) {
      Page page = new Page(lang, context, act);
      page.init();
      Label label = new Label(Translation.language(lang));
      notebook.append_page(page, label);
      pages.append_val(page);
    }
    box.pack_start(notebook, true, true);

    ActionBar actionBar = new ActionBar();
    Label ps1 = new Label(Translation.wording(Configuration.languages()[0], Wording.PS1).printf(
          Translation.userType(Configuration.languages()[0], context.userType),
          context.userName,
          context.hostName));
    ps1.xalign = 0;
    ps1.use_markup = true;
    actionBar.add(ps1);
    box.pack_end(actionBar, false, false);

    window.add(box);
    window.show_all();
  }

  public void renderStatus(Status status) {
    for (int i = 0; i < pages.length; i++) {
      pages.index(i).renderStatus(status);
    }
  }

}

/**
 * class Page
 * A page within Activity
 */
class Page : Box {
  private Language lang;
  private Context context;
  private unowned Activity.Act act;

  Label titleLabel;
  Label messageLabel;
  Label progressLabel;
  Box radioButtons;
  RadioButton logout;
  RadioButton forceCheckout;
  RadioButton forceLogin;
  RadioButton transient;

  private Action selectedAction;
  private Status? _status;

  public Page(Language lang, Context context, Activity.Act act) {
    Object(orientation: Orientation.VERTICAL, spacing: Configuration.SPACING);
    border_width = Configuration.SPACING;
    this.lang = lang;
    this.context = context;
    this.act = act;
    selectedAction = Action.LOGOUT;
    _status = null;
  }

  public void renderStatus(Status status) {
    bool still = status == _status;
    _status = status;
    switch (status) {
      case Status.GUEST:
        if (still) {
          break;
        }
        title = Translation.wording(lang, Wording.GUEST_TITLE);
        message = Translation.wording(lang, Wording.GUEST_MESSAGE);
        options = {transient, logout};
        transient.set_active(true);
        selectedAction = Action.TRANSIENT;
        break;
      case Status.CHECKING:
        if (context.downloadTask == null) {
          progress = Translation.wording(lang, Wording.PLEASE_WAIT);
        } else if (context.downloadExit != null) {
          progress = Translation.wording(lang, Wording.CHECKING_ERROR);
        } else if (context.downloadStatus == null) {
          progress = Translation.wording(lang, Wording.CHECKING_STARTED);
        } else {
          progress = context.downloadStatus;
        }
        if (still) {
          break;
        }
        title = Translation.wording(lang, Wording.CHECKING_TITLE);
        message = Translation.wording(lang, Wording.CHECKING_MESSAGE);
        options = {logout, forceLogin, transient};
        logout.set_active(true);
        selectedAction = Action.LOGOUT;
        break;
      case Status.CONFLICT:
        if (context.logoutFile.content == null) {
          progress = Translation.wording(lang, Wording.CONFLICT_ISSUED);
        } else {
          progress = context.logoutFile.content;
        }
        if (still) {
          break;
        }
        title = Translation.wording(lang, Wording.CONFLICT_TITLE);
        message = Translation.wording(lang, Wording.CONFLICT_MESSAGE).printf(context.checkoutFile.content);
        options = {logout, forceCheckout, transient};
        logout.set_active(true);
        selectedAction = Action.LOGOUT;
        break;
      default:
        fatal("Unknown Status");
        break;
    }
  }

  public void init() {
    titleLabel = new Label(null);
    titleLabel.xalign = 0;
    titleLabel.use_markup = true;
    add(titleLabel);
    messageLabel = new Label(null);
    messageLabel.xalign = 0;
    messageLabel.set_line_wrap(true);
    add(messageLabel);
    progressLabel = new Label(null);
    progressLabel.xalign = 0;
    progressLabel.set_line_wrap(true);
    add(progressLabel);

    radioButtons = new Box(Orientation.VERTICAL, Configuration.SPACING);
    logout = new RadioButton.with_label_from_widget(null, Translation.action(lang, Action.LOGOUT));
    logout.toggled.connect((b) => { selectedAction = Action.LOGOUT; });
    forceCheckout = new RadioButton.with_label_from_widget(logout, Translation.action(lang, Action.FORCE_CHECKOUT));
    forceCheckout.toggled.connect((b) => { selectedAction = Action.FORCE_CHECKOUT; });
    forceLogin = new RadioButton.with_label_from_widget(logout, Translation.action(lang, Action.FORCE_LOGIN));
    forceLogin.toggled.connect((b) => { selectedAction = Action.FORCE_LOGIN; });
    transient = new RadioButton.with_label_from_widget(logout, Translation.action(lang, Action.TRANSIENT));
    transient.toggled.connect((b) => { selectedAction = Action.TRANSIENT; });
    Button okButton = new Button.with_label(Translation.wording(lang, Wording.OK));
    okButton.clicked.connect(() => { act(selectedAction); });
    pack_end(okButton, false, false);
    pack_end(radioButtons, false, false);

    _options = {};

    show_all();
  }

  private string title {
    set {
      titleLabel.label = "<span font_desc='15'>" + value + "</span>";
    }
  }

  private string message {
    set {
      messageLabel.label = value;
    }
  }

  private string progress {
    set {
      progressLabel.label = value;
    }
  }

  private RadioButton[] _options;
  private RadioButton[] options {
    set {
      foreach (RadioButton b in _options) {
        radioButtons.remove(b);
      }
      foreach (RadioButton b in value) {
        radioButtons.add(b);
      }
      radioButtons.show_all();
      _options = value;
    }
  }

}

MainLoop? mainLoop;

/**
 * class BacchusLogin
 * Handles initialization
 */
class BacchusLogin : Object {
  public static int main(string[] args) {
    mainLoop = null;

    /* Prepare main context */
    string? hostName = new SingleLineFile(Configuration.stringKey(StringKey.HOSTNAME)).content;
    if (hostName == null) {
      fatal("Cannot get hostname");
    }
    string? userName = Environment.get_variable(Configuration.stringKey(StringKey.USER));
    if (userName == null) {
      fatal("Cannot get userName");
    }
    Objective? objective = null;
    UserType? userType = null;
    for (int i = 0; i < args.length; i++) {
      if (i == 0) {
        continue;
      }
      Objective? objective_current = Configuration.option2Objective(args[i]);
      if (objective_current != null) {
        if (objective != null) {
          fatal("Duplicate option for Objective");
        }
        objective = objective_current;
        continue;
      }
      UserType? userType_current = Configuration.option2UserType(args[i]);
      if (userType_current != null) {
        if (userType != null) {
          fatal("Duplicate option for UserType");
        }
        userType = userType_current;
        continue;
      }
      fatal("Unknown option");
    }
    if (objective == null) {
      fatal("Objective not provided");
    }
    if (userType == null) {
      fatal("UserType not provided");
    }
    if (objective == Objective.LOGOUT && userType == UserType.GUEST) {
      fatal("Unsupported context: <logout, guest>");
    }
    Context context = new Context(hostName, userName, userType, objective);
    context.init();

    /* Prepare activity and updateIteration */
    Activity activity;
    if (objective == Objective.LOGIN) {
      Gtk.init(ref args);
      activity = new Activity(context, (action) => { context.act(action); });
      activity.init();
    } else {
      activity = null;
    }
    UpdateIteration updateIteration = new UpdateIteration(context, activity);

    /* do work */
    GLib.Timeout.add(Configuration.UPDATE_MILLISEC, () => { return updateIteration.iterate(); });
    updateIteration.iterate();

    /* wait */
    if (objective == Objective.LOGIN) {
      if (context.exit_status == null) {
        Gtk.main();
      }
    } else {
      if (context.exit_status == null) {
        mainLoop = new MainLoop();
        mainLoop.run();
      }
    }

    return context.exit_status;
  }
}
