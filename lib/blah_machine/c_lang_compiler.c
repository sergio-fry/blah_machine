#include <stdio.h>

int strlen(char* str) {
  int i = 0;

  while(str[i] != 0) {
    i++;
  }

  return i;
}

// 0 - equal
// 1 - not equal
int strcmp(char* str1, char* str2) {
  int result = 0;
  int length = strlen(str1);

  if(strlen(str1) == strlen(str2)) {
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

int strcpy(char* src, char* dest) {
  int length = strlen(src);

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

// Variable defenition
const int STATE_VD_TYPE = 30;
const int STATE_VD_NAME = 31;

const STATE_STATEMENT = 40;

int is_identifier_first_char(char ch) {
  return (ch >= 'a' && ch <= 'z') || 
    (ch >= 'A' && ch <= 'Z');
}

int is_identifier_char(char ch) {

  return (ch >= 'a' && ch <= 'z') || 
    (ch >= 'A' && ch <= 'Z') ||
    (ch >= '0' && ch <= '9') ||
    ch == '_';
}

int is_identifier(char* str) {
  int length = strlen(str), result = 1;

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
    if(strcmp(token, ")") == 0) {
      *current_state = STATE_FD_ARGUMENTS_LIST_END;
    }
  } else if(*current_state == STATE_FD_ARGUMENTS_LIST_END) {
    if(strcmp(token, "{") == 0) {
      *current_state = STATE_FD_BODY_START;
    }
  } else if(*current_state == STATE_FD_BODY_START) {
    if(strcmp(token, "}") != 0) {
      *current_state = STATE_FD_BODY;
      next_state(current_state, token);
    }
  } else if(*current_state == STATE_FD_BODY) {
    if(strcmp(token, "}") == 0) {
      *current_state = STATE_FD_BODY_END;
    } else if(strcmp(token, "int") == 0) {
      *current_state = STATE_VD_TYPE;
    } else if(is_identifier(token)) {
      *current_state = STATE_STATEMENT;
    }
  } else if (*current_state == STATE_STATEMENT) {
    if(strcmp(token, ";") == 0) {
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
  } else {
    token[0] = source_code[position];
    token[1] = '\0';
    position++;
  }

  *current_position = position;

  return 0;
}

const int FUNCTIONS_TABLE_MAX_SIZE = 255;
const int VARIABLES_TABLE_MAX_SIZE = 255;

int main() {
  char* source_code = "\
  int sum(int a, int b) {\
    int c; \
    c = a + b; \
    return c; \
  } \
  int main() { \n\
    return 0; \n\
  }";

  int source_code_length = strlen(source_code);
  char token[255];

  int current_position = 0;
  int current_state = STATE_ROOT;

  char functions_table[FUNCTIONS_TABLE_MAX_SIZE][255];
  int functions_count = 0;

  while(current_position < source_code_length) {
    read_next_token(source_code, &current_position, token);

    next_state(&current_state, token);

    printf("%2d | %s \n", current_state, token);
  }

  return 0;
}
