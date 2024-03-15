FROM pandoc/latex 

RUN apk add --update nodejs npm
RUN npm install --global mermaid-filter
