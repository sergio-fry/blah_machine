#include <stdio.h>
int mystrappend(char* str1, char* str2) {
  int str1_length = mystrlen(str1);
  int str2_length = mystrlen(str2);

  int i = 0;

  while(i < str2_length) {
    str1[str1_length + i] = str2[i];
    i++;
  }
  str1[str1_length + i] = '\0';

  return 0;
}

int mystrlen(char* str) {
  int i = 0;

  while(str[i] != 0) {
    i++;
  }

  return i;
}

// 0 - equal
// 1 - not equal
int mystrcmp(char* str1, char* str2) {
  int result = 0;
  int length = mystrlen(str1);

  if(mystrlen(str1) == mystrlen(str2)) {
    int i = 0;

    while(i < length) {
      if(str1[i] != str2[i]) {
        result = 1;
        break;
      }

      i++;
    }
  } else {
    result = 1;
  }

  return result;
}

int mystrcpy(char* src, char* dest) {
  int length = mystrlen(src);

  int i = 0;
  while(i <= length) {
    dest[i] = src[i];

    i++;
  }

  return 0;
}

const int STATE_ROOT = 0;

// Function defenition (FD)
const int STATE_FD_TYPE = 10;
const int STATE_FD_NAME = 12;
const int STATE_FD_ARGUMENTS_LIST_START = 14;
const int STATE_FD_ARGUMENT_TYPE = 15;
const int STATE_FD_ARGUMENT_NAME = 16;
const int STATE_FD_ARGUMENTS_LIST_END = 17;
const int STATE_FD_BODY_START = 18;
const int STATE_FD_BODY = 19;
const int STATE_FD_BODY_END = 20;
const int STATE_FD_RETURN = 21;

// Variable defenition
const int STATE_VD_TYPE = 30;
const int STATE_VD_NAME = 31;

const STATE_STATEMENT = 40;

int is_digit(char ch) {
  return (ch >= '0' && ch <= '9');
}

int is_identifier_first_char(char ch) {
  return (ch >= 'a' && ch <= 'z') || 
    (ch >= 'A' && ch <= 'Z');
}

int is_identifier_char(char ch) {

  return (ch >= 'a' && ch <= 'z') || 
    (ch >= 'A' && ch <= 'Z') ||
    is_digit(ch) ||
    ch == '_';
}

int is_identifier(char* str) {
  int length = mystrlen(str), result = 1;

  int i = 0;
  while(i < length) {
    if((i == 0 && !is_identifier_first_char(str[i])) ||
        !is_identifier_char(str[i])) {
      result = 0;
      break;
    }

    i++;
  }

  return result;
}

int is_space(char ch) {
  return ch == ' ' || ch == '\n';
}

int is_corrent_tokken_first_char(char ch) {
  return is_identifier_char(ch) || 
    ch == ';' ||
    ch == '(' ||
    ch == ')' ||
    ch == '{' ||
    ch == '}' ||
    ch == ',';
}

// 0 - SUCCESS
int next_state (int* current_state, char* token) {
  int result = 0; 
  if(*current_state == STATE_ROOT) {
    *current_state = STATE_FD_TYPE;
  } else if(*current_state == STATE_FD_TYPE) {
    *current_state = STATE_FD_NAME;
  } else if(*current_state == STATE_FD_NAME) {
    *current_state = STATE_FD_ARGUMENTS_LIST_START;
  } else if(*current_state == STATE_FD_ARGUMENTS_LIST_START) {
    if(mystrcmp(token, ")") == 0) {
      *current_state = STATE_FD_ARGUMENTS_LIST_END;
    }
  } else if(*current_state == STATE_FD_ARGUMENTS_LIST_END) {
    if(mystrcmp(token, "{") == 0) {
      *current_state = STATE_FD_BODY_START;
    }
  } else if(*current_state == STATE_FD_BODY_START) {
    if(mystrcmp(token, "}") != 0) {
      *current_state = STATE_FD_BODY;
      next_state(current_state, token);
    }
  } else if(*current_state == STATE_FD_BODY) {
    if(mystrcmp(token, "}") == 0) {
      *current_state = STATE_FD_BODY_END;
    } else if(mystrcmp(token, "int") == 0) {
      *current_state = STATE_VD_TYPE;
    } else if(mystrcmp(token, "return") == 0) {
      *current_state = STATE_FD_RETURN;
    } else if(is_identifier(token)) {
      *current_state = STATE_STATEMENT;
    }
  } else if(*current_state == STATE_FD_RETURN) {
    *current_state = STATE_STATEMENT;
  } else if (*current_state == STATE_STATEMENT) {
    if(mystrcmp(token, ";") == 0) {
      *current_state = STATE_FD_BODY;
    }
  } else if(*current_state == STATE_VD_TYPE) {
    *current_state = STATE_VD_NAME;

  } else if(*current_state == STATE_VD_NAME) {
    *current_state = STATE_FD_BODY;
  } else if(*current_state == STATE_FD_BODY_END) {
    *current_state = STATE_FD_TYPE;
  }

  return result;
}

int read_next_token_and_update_state(char* source_code, int* current_position, int* current_state, char* token) {
  read_next_token(source_code, current_position, token);
  next_state(current_state, token);

  return 0;
}

int read_next_token(char* source_code, int* current_position, char* token) {
  int position = *current_position;

  // skip spaces
  while(is_space(source_code[position])) { position++; };

  int i = 0;

  if(is_identifier_first_char(source_code[position])) {
    while(is_identifier_char(source_code[position])) {
      token[i] = source_code[position];
      position++; i++;
    }
    token[i] = '\0';
  } else if(is_digit(source_code[position])) {
    while(is_digit(source_code[position])) {
      token[i] = source_code[position];
      position++; i++;
    }
    token[i] = '\0';
  } else {
    token[0] = source_code[position];
    token[1] = '\0';
    position++;
  }

  *current_position = position;
}

int read_expression_inside_bracets(char* source_code, int* current_position, char* expression) {
  int opened_bracets;
  char token[255];

  expression[0] = '\0';

  opened_bracets = 1;
  *current_position = *current_position + 1; // skip first bracet

  while(opened_bracets > 0) {
    read_next_token(source_code, current_position, token);

    if(mystrcmp(token, ")") == 0) {
      opened_bracets--;
    } else if(mystrcmp(token, "(") == 0) {
      opened_bracets++;
    }

    if(opened_bracets > 0) {
      mystrappend(expression, token);
    }
  }
}

const int FUNCTIONS_TABLE_MAX_SIZE = 255;
const int VARIABLES_TABLE_MAX_SIZE = 255;
const int STATEMENT_MAX_SIZE = 1024;

int convert_statement_to_functions(char* statement, char* result) {
  char statement_tmp[STATEMENT_MAX_SIZE];

  int statement_length = mystrlen(statement);

  int position = 0;
  char token[255]; token[0] = '\0';
  char argument_1[255];
  char argument_1_prepared[255];
  char statement_tail[STATEMENT_MAX_SIZE];
  char statement_tail_prepared[STATEMENT_MAX_SIZE];
  int i;

  // find first operation
  while(position < statement_length) {

    if(mystrcmp(token, "=") * mystrcmp(token, "+") == 0) {
      break;
    } else if (mystrcmp(token, "(") == 0) {
      // read expression inside bracets ( ... )
      position--;
      read_expression_inside_bracets(statement, &position, argument_1);
    } else {
      mystrcpy(token, argument_1);
    }

    read_next_token(statement, &position, token);
  }

  if(position >= statement_length) {
    if(mystrlen(argument_1) > 0) {
      convert_statement_to_functions(argument_1, argument_1_prepared);
      sprintf(result, "%s", argument_1_prepared);
    } else {
      sprintf(result, "%s", token);
    }
  } else {
    i = 0;

    // read the rest statement
    while(position <= statement_length) {
      statement_tail[i] = statement[position];
      position++; i++;
    }

    convert_statement_to_functions(statement_tail, statement_tail_prepared);
    convert_statement_to_functions(argument_1, argument_1_prepared);
    sprintf(result, "%s(%s, %s)", token, argument_1_prepared, statement_tail_prepared);
  }

  printf("%s -> %s \n", statement, result);
}

int main() {
  char* source_code = "\
  int sum(int a, int b) {\
    int c; \
    c = a + b; \
    return c; \
  } \
  int main() { \n\
    int a; \
    int b; \
    a = (b + (a + c + 1)) + 34; \
    a = b + 1 + 34; \
    a = (b + 1) + 34; \
    b = a + b + a + 4 + a; \
    return 0; \n\
  }";

  int source_code_length = mystrlen(source_code);
  char token[255];

  int current_position = 0;
  int current_state = STATE_ROOT;

  char functions_table[FUNCTIONS_TABLE_MAX_SIZE][255];
  int functions_count = 0;

  char statement[STATEMENT_MAX_SIZE];
  char statement_prepared[STATEMENT_MAX_SIZE];

  while(current_position < source_code_length) {
    read_next_token_and_update_state(source_code, &current_position, &current_state, token);

    if(current_state == STATE_STATEMENT) {
      statement[0] = '\0';

      mystrappend(statement, token);

      while(current_state == STATE_STATEMENT) {
        read_next_token_and_update_state(source_code, &current_position, &current_state, token);
        if (current_state == STATE_STATEMENT) {
          mystrappend(statement, token);
        }
      }

      convert_statement_to_functions(statement, statement_prepared);

    }
  }

  return 0;
}
