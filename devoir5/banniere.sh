#!/usr/bin/env bash

show_help () {
  echo "banniere [paramètres mot-clefs] message"
  echo ""
  echo "-h         : affiche ce message"
  echo "-mt car    : caractère du motif du contour"
  echo "-mg nombre : marge entre le message et le contour"
  echo "-ep nombre : épaisseur du motif"
  echo "--         : pour indiquer la fin des paramètres positionnels"
  echo "message : le message à afficher; doit être le dernier paramètre"
}

assert_single_char () {
  SUBJECT=$1
  VALUE=$2
  if (( ${#VALUE} != 1 )) ; then
    # Показываем ошибку
    echo "doit retourner une erreur: ${SUBJECT}"
    echo ""
    show_help
    # Используем return чтоб вернуть код ошибки
    return 1
  fi
}

assert_positive_number () {
  SUBJECT=$1
  VALUE=$2
  if (( VALUE <= 0 )) ; then
    # Показываем ошибку и выходим из программы
    echo "doit retourner une erreur: ${SUBJECT}"
    echo ""
    show_help
    # Используем return чтоб вернуть код ошибки
    return 1
  fi
}

assert_length () {
  SUBJECT=$1
  VALUE=$2
  if (( ${#VALUE} < 1 )) ; then
    # Показываем ошибку и выходим из программы
    echo "doit retourner une erreur: ${SUBJECT}"
    echo ""
    show_help
    # Используем return чтоб вернуть код ошибки
    return 1
  fi
}

assert_not_parameter () {
  VALUE=$1
  if [[ ${VALUE:0:1} = "-" ]] ; then
    # Показываем ошибку и выходим из программы
    echo "doit retourner une erreur: paramètre ${VALUE} invalide"
    echo ""
    show_help
    # Используем return чтоб вернуть код ошибки
    return 1
  fi
}

repeat_char () {
  # Первым аргументом функции будет повторяющийся символ
  CHAR="$1"
  # Вторым аргументом функции будет кол-во повторений
  LENGTH=$2
  # В эту переменную будем конкатинировать (не зняю как на рус., на анг. concatenation, т.е. объединение нескольких строк)
  # Зачем она нам нужно, почему сразу не печатать, потому что `echo` выводит строчку,
  # т.е. второй раз `echo` напечатает на новой строке, а нам надо символы в одной строке
  STR=""
  # Цикл повторений от одного до указанного LENGTH с шагом +1
  for (( i=1; i<=${LENGTH}; i++ )) ; do
    # Объденеям предудщую строку с очередным симолом
    STR="${STR}${CHAR}"
  done

  # Строка готова печатаем
  echo "${STR}"
}

print_banner () {
  # Слово на баннере, первым аргументом функции, т.к. должна быть возможность это указать при вызове функции и скрипта
  MESSAGE=$1
  # Символ по бокам, указывается аргументом, т.к. он настраеваемый
  MARGIN_CHAR=$2
  # Количество повторении обрамления, также настраивается третим аргументом функции
  MARGIN_LENGTH=$3
  # Количество пробелов в разделителе.
  PADDING_LENGTH=$4
  # Символ разделитель обрамления и слова. Используется пробле, без возможности настраить.
  PADDING_CHAR=" "

  # Генерируем край
  MARGIN="$( repeat_char "${MARGIN_CHAR}" ${MARGIN_LENGTH} )"
  # Генерируем разделитель
  PADDING="$( repeat_char "${PADDING_CHAR}" ${PADDING_LENGTH} )"

  # Вычисляем длину заголовка, в баше это делает диез после фигурной скобки
  LABEL_LENGTH=${#MESSAGE}

  # Вычисляем длину линий сверху/снизу
  # Матемитические операии делаются в баше при помощи двух круглых скобок
  BORDER_LENGTH=$(( LABEL_LENGTH + MARGIN_LENGTH * 2 + PADDING_LENGTH * 2 ))

  # Печатаем баннер
  repeat_char "${MARGIN_CHAR}" ${BORDER_LENGTH}
  repeat_char "${MARGIN_CHAR}" ${BORDER_LENGTH}
  echo "${MARGIN}${PADDING}${MESSAGE}${PADDING}${MARGIN}"
  repeat_char "${MARGIN_CHAR}" ${BORDER_LENGTH}
  repeat_char "${MARGIN_CHAR}" ${BORDER_LENGTH}
}

# Заголовок банера. Переменная куда запишем то что пришло из командной строки
MESSAGE=""
# Символ для обрамления. Переменная куда запишем то что пришло из командной строки. По умолчанию "*".
# Помним для одинарныые ковычки для спец символов.
MARGIN_CHAR='*'
# Длина обрамления. Переменная куда запишем то что пришло из командной строки. По умолчанию 3.
MARGIN_LENGTH=3
# Длина отступа между обрамлением и заголовком. Переменная куда запишем то что пришло из командной строки. По умолчанию 3.
PADDING_LENGTH=3

# Обрабатываем ключи
while [ -n "$1" ] ; do
  # тут будут проверки $1
  case "$1" in
    # При `--` завершаем цикл, т.к. этот параметр означает что закончились ключи и дальше остаются только параметры.
    # завершения цикл при помощи команды `break`.
    # Внимание сейчас в аргументах `-- другие параметры`, а нам `--` не нужен, делаем `shift` до `break`,
    # чтобы выбрасить его.
    --) shift ; break ;;
    # При `-h` показать справку. Можно праму тут написать echo "bla bla", а можно вынести в функцию.
    # exit при этом сценарии сразу, не выполняя дальше скрипт.
    -h) show_help ; exit ;;
    # Если $1 равен `-mt`, то следующий $2 будет символ который нам нужен в MARGIN_CHAR.
    # После того как мы использовали $1 и $2 они нам не нужны больше, т.е. shift их оба из аргументов.
    -mt) MARGIN_CHAR=$2 ; shift ; shift ;;
    # Если $1 равен `-mg`, то следующий $2 будет цифра который нам нужен в MARGIN_LENGTH.
    # После того как мы использовали $1 и $2 они нам не нужны больше, т.е. shift их оба из аргументов.
    -mg) MARGIN_LENGTH=$2 ; shift ; shift ;;
    # Если $1 равен `-ep`, то следующий $2 будет цифра который нам нужен в PADDING_LENGTH.
    # После того как мы использовали $1 и $2 они нам не нужны больше, т.е. shift их оба из аргументов.
    -ep) PADDING_LENGTH=$2 ; shift ; shift ;;
    # Если ничего из этого, значит это message который не был разделен `--` либо другой неизвестный ключ.
    *)
      # Проверяем не является ли $1 ключе (нет ли тире в начале). Если это не известный ключ показываем ошибку и выходм из программы.
      assert_not_parameter $1 || exit 1
      # Если же нет, то там message, завершаем цикл т.к. дальше проверок не нужно.
      break ;;
  esac
done


# Обрабатываем параметры после ключей.
# Ключи мы уже все выбрасили при помомощи shift в while,
# т.е. в аргументах командной строки (`$@`, `$*`) остались только параметры.
# По условию задания все это является сообщением для баннера.
MESSAGE=$*

assert_single_char "caractère du motif du contour" "${MARGIN_CHAR}" || exit 1
assert_positive_number "marge invalide" ${MARGIN_LENGTH} || exit 1
assert_positive_number "épaisseur invalide" ${PADDING_LENGTH} || exit 1
assert_length "message" "${MESSAGE}" || exit 1

print_banner "${MESSAGE}" "${MARGIN_CHAR}" ${MARGIN_LENGTH} ${PADDING_LENGTH}
