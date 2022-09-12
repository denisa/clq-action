FROM denisa/clq:1.7.3-alpine
COPY action.sh /usr/bin/action.sh
ENTRYPOINT ["/usr/bin/action.sh"]
