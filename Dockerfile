FROM denisa/clq:1.6.0-alpine
COPY action.sh /usr/bin/action.sh
ENTRYPOINT ["/usr/bin/action.sh"]
