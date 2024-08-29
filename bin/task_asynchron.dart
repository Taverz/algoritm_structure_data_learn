import 'dart:async';

void main() async {
  // ExempoleSimple().mainSimple();
  ExampleHard().mainHard();
}

/// ----------------


/// Этот код выполняется таким образом из-за особенностей работы с асинхронными задачами (Futures) и микротасками (microtasks) в Dart. Давайте пошагово разберем выполнение кода.
/// ### 1. `mainSimple` запускается:
/// - **Вывод**: `Start main`
/// - Вызов `methodA()` происходит без `await`, поэтому выполнение кода продолжается без ожидания его завершения.
/// - Далее вызывается `await methodB('main');`, что приостанавливает выполнение `mainSimple` до завершения `methodB`.
/// ### 2. Выполняется `methodA()`:
/// - **Вывод**: `A start`
/// - `methodA()` вызывает `await methodB('A');`, что приостанавливает выполнение `methodA` до завершения `methodB`.
/// ### 3. Выполняется `methodB('A')`:
/// - **Вывод**: `B start from A`
/// - Создается и выполняется `Future`, в котором происходит вывод `B running Future from A`.
/// - **Вывод**: `B running Future from A`
/// - После выполнения Future, вызывается `then`, и в консоль выводится `B end of Future from A`.
/// - **Вывод**: `B end of Future from A`
/// - Затем выполняется микротаска с выводом `microtask from A`, но это произойдет позже, когда основной код завершит свою работу (в конце этой задачи).
/// - **Вывод**: `B end from A`
/// - `methodB('A')` завершается, и управление возвращается в `methodA`.
/// ### 4. Возвращаемся в `methodA`:
/// - **Вывод**: `A end`
/// - `methodA` завершает свою работу, управление возвращается в `mainSimple`.
/// ### 5. Возвращаемся в `mainSimple`:
/// - Продолжается выполнение после `await methodB('main');`.
/// - В этот момент вызывается `methodB('main')`.
/// ### 6. Выполняется `methodB('main')`:
/// - **Вывод**: `B start from main`
/// - Как и в случае с `methodB('A')`, создается и выполняется `Future`, который выводит `B running Future from main`.
/// - **Вывод**: `B running Future from main`
/// - После выполнения Future, вызывается `then`, и в консоль выводится `B end of Future from main`.
/// - **Вывод**: `B end of Future from main`
/// - Затем выполняется микротаска с выводом `microtask from main`, но снова это произойдет позже.
/// - **Вывод**: `B end from main`
/// - `methodB('main')` завершает свою работу, управление возвращается в `mainSimple`.
/// ### 7. Завершение `mainSimple`:
/// - **Вывод**: `End main`
/// - `mainSimple` завершается.
/// ### 8. Выполнение микротасок:
/// - После завершения всех вышеупомянутых операций, в очередь на выполнение попадают микротаски, которые были запланированы в методах `methodB`.
/// - **Вывод**: `microtask from A`
/// - **Вывод**: `microtask from main`
/// ### Итак, почему код выполняется именно в таком порядке?
/// 1. **Асинхронные задачи и `await`:** Методы, которые используют `await`, приостанавливают выполнение текущего метода до завершения асинхронной задачи. Код после `await` выполняется только после завершения этой задачи.
/// 2. **Микротаски:** Микротаски, запланированные с помощью `Future.microtask`, выполняются после завершения всех текущих задач и перед следующей задачей из очереди событий. Это происходит в конце каждого соответствующего метода `methodB`.
/// Именно из-за этого микротаски выводятся в конце, после завершения всех основных задач.

/// ------  ----------

/// Да, в этом коде используется и работает **Event Loop** (цикл событий) Dart. Давайте разберем, как он взаимодействует с вашим кодом.
/// ### Что такое Event Loop?
/// В Dart, как и в других языках с асинхронной моделью, Event Loop управляет выполнением кода, задач и событий в приложении. Он обеспечивает выполнение задач в правильной последовательности и переключение между задачами, когда это необходимо.
/// ### Как Event Loop работает с вашим кодом?
/// 1. **Синхронный код** выполняется сразу, по порядку, когда он встречается в потоке выполнения программы.
/// 2. **Асинхронный код**, такой как `Future` или `async/await`, создает задачи, которые добавляются в очередь задач (event queue). Эти задачи выполняются позже, когда Event Loop доходит до них.
/// 3. **Микротаски (microtasks)** — это специальный тип задач, который выполняется после завершения текущей синхронной задачи и перед тем, как Event Loop перейдет к следующему событию из основной очереди задач.
/// ### Пример работы Event Loop в вашем коде:
/// 1. **Запуск `mainSimple`:**  
///    Синхронные операции (например, `print('Start main')`) выполняются сразу. Асинхронные задачи (вызовы `await` и `Future`) добавляются в очередь задач.
/// 2. **Выполнение `methodA`:**  
///    Внутри этого метода вызывается `methodB('A')`. `methodB` создает асинхронную задачу (`Future`), которая добавляется в очередь. Основной код метода `methodB` (до `await`) выполняется синхронно, а остальная часть после `await` выполняется позже, когда задача из Future будет завершена.
/// 3. **Очередь микротасок:**  
///    Когда внутри `methodB` вызывается `Future.microtask`, эта микротаска добавляется в специальную очередь микротасок. Эти микротаски выполняются, когда основная часть синхронного кода завершится, но до перехода к следующей задаче из очереди.
/// 4. **Обработка Event Loop:**  
///    Event Loop сначала обрабатывает синхронный код, затем выполняет микротаски, затем асинхронные задачи (обычные `Future`), и только потом переходит к следующим задачам или событиям.
/// ### Подробное объяснение по шагам:
/// - **Сначала** выполняется синхронный код (`print` и вызовы методов).
/// - Когда Event Loop доходит до `await methodB('main');`, выполнение `mainSimple` приостанавливается до завершения асинхронной задачи.
/// - **Затем** Event Loop обрабатывает задачи в порядке их добавления в очередь (например, выполнение `Future` внутри `methodB`).
/// - **Микротаски** (запланированные `Future.microtask`) выполняются после завершения основной части метода `methodB` и до возобновления работы `mainSimple`.
/// - В конце Event Loop возобновляет выполнение `mainSimple` после завершения всех асинхронных задач.
/// ### Итак, Event Loop:
/// - **Да**, он работает в этом коде.
/// - **Управляет** порядком выполнения задач и микротасок, обеспечивая асинхронное выполнение и правильное переключение контекста.
/// Event Loop в Dart выполняет ключевую роль в управлении временем выполнения вашего асинхронного кода и поддержании его правильного порядка.
class ExempoleSimple {
  /// - Start main  
  /// - A start  
  /// - B start from A  
  /// - B start from main  
  /// - B running Future from A  
  /// - B end of Future from A  
  /// - B end from A  
  /// - A end  
  /// - microtask from A  
  /// - B running Future from main  
  /// - B end of Future from main  
  /// - B end from main  
  /// - End main  
  /// - microtask from main  
  void mainSimple() async {
    print('Start main');
    methodA();
    await methodB('main');
    print('End main');
    // Запуск микротаски
    // scheduleMicrotask(() {
    //   print('Микротаска выполнена');
    // });
  }

  Future<void> methodA() async {
    print('A start');
    await methodB('A');
    print('A end');
  }

  Future<void> methodB(String from) async {
    print('B start from $from');
    await Future(
      () => print('B running Future from $from'),
    ).then((value) => print('B end of Future from $from'));
    // Запуск микротаски
    Future.microtask(() => print('microtask from $from'));

    print('B end from $from');
  }
}


/// ----------------

class ExampleHard {

  /// - Start main
  /// - A start
  /// - B start from A
  /// - B delayed Future from A
  /// - B running Future from A
  /// - B end of Future from A
  /// - B end from A
  /// - A end
  /// - B start from main
  /// - microtask from A
  /// - B delayed Future from main
  /// - B running Future from main
  /// - B end of Future from main
  /// - B end from main
  /// - C start
  /// - microtask from main
  /// - Timer from A
  /// - C Future 1 done
  /// - Timer from main
  /// - C Future 2 done
  /// - C end
  /// - End main
  /// - [Done] exited with code=0 in 4.3 seconds
  void mainHard() async {
    print('Start main');

    await methodA();
    await methodB('main');

    // Запуск дополнительной асинхронной функции
    await methodC();

    print('End main');
  }

  Future<void> methodA() async {
    print('A start');
    await methodB('A');
    print('A end');
  }

  Future<void> methodB(String from) async {
    print('B start from $from');

    // Future с задержкой
    await Future.delayed(
        Duration(seconds: 1), () => print('B delayed Future from $from'));

    // Обычный Future
    await Future(() => print('B running Future from $from'))
        .then((value) => print('B end of Future from $from'));

    // Микрозадача
    Future.microtask(() => print('microtask from $from'));

    // Таймер
    Timer(Duration(seconds: 2), () => print('Timer from $from'));

    print('B end from $from');
  }

  Future<void> methodC() async {
    print('C start');

    // Параллельный запуск нескольких Future
    await Future.wait([
      Future.delayed(Duration(seconds: 1), () => print('C Future 1 done')),
      Future.delayed(Duration(seconds: 2), () => print('C Future 2 done')),
    ]);

    print('C end');
  }
}




/// ---- ---- ----
/// - В Dart микротаски (microtasks) имеют приоритет перед задачами в основной очереди событий (event queue).
/// - ## Как это работает?
/// - Очередь событий (Event Queue): Это основная очередь, в которую попадают асинхронные задачи, такие как таймеры, сетевые запросы, операции с файлами и обычные Future. 
///   Эти задачи обрабатываются по мере освобождения Event Loop.
/// - Очередь микротасок (Microtask Queue): Это специальная очередь, в которую попадают задачи, запланированные с помощью scheduleMicrotask или Future.microtask. 
///   Микротаски выполняются с более высоким приоритетом по сравнению с задачами в основной очереди событий.
/// - ## Приоритет микротасок:
/// - После завершения синхронного кода и перед тем, как Event Loop перейдет к следующей задаче из основной очереди событий, Dart сначала выполняет все микротаски, которые находятся в очереди микротасок.
/// - Если в процессе выполнения одной микротаски добавляются новые микротаски, они также будут выполнены до того, как Event Loop перейдет к следующей задаче из основной очереди событий.
/// ---- ---- ----
/// - Start main
/// - End main
/// - Microtask 1
/// - Microtask 2
/// - Event 2
/// - Event 1
/// ---- ---- ----
void eventLoop() {
  print('Start main');

  scheduleMicrotask(() {
    print('Microtask 1');
  });

  Future.delayed(Duration(seconds: 1), () {
    print('Event 1');
  });

  scheduleMicrotask(() {
    print('Microtask 2');
  });

  Future(() {
    print('Event 2');
  });

  print('End main');
}


