FROM legionio/legion

COPY . /usr/src/app/lex-openai

WORKDIR /usr/src/app/lex-openai
RUN bundle install
