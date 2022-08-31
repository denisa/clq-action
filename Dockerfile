FROM denisa/clq:1.7.1-alpine
COPY action.sh /usr/bin/action.sh
ENTRYPOINT ["/usr/bin/action.sh"]
