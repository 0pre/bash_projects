# Bash Projects

This repository stores different projects made in bash, independent of each other. The documentation, description and use of each one will be updated here.

## HTB Explorer

This search engine allows us to filter by keywords for the machines listed by the content creator [s4vitar](https://www.youtube.com/c/s4vitar) from the HackTheBox platform. You can filter by difficulty and Operative System at the same time.

```bash
./htb_explorer.sh -h | -u | -y <name> | -n <name> | -d <Easy/Medium/Hard/Insane> | -o <os> | -s "<Skill>"
```

### Example

```bash
./htb_explorer.sh -d Medium -o Linux
```
