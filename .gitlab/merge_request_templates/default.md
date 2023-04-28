# Prologue
**We DO NOT ACCEPT ANY PULL/MERGE REQUEST FOR THIS REPOSITORY**.

The right procedure for contributing back via these platform services ARE:

1. **Generate and submit your patches into your corresponding issue ticket**;
2. Feel free to ask any technical questions about patch generations;
3. Once the basic are cleared, We will `git am` (apply) the submitted patch. If
   it works, it will then be treated as accepted.




# Why?
We want to:

1. **Retaining all changes and information inside git log ONLY**; and
2. **Avoiding complete vendor locked-in**; and
3. **Continue to facilitate offline and disconnected native git services**

Like it or not, any GVCS (e.g. GitHub/GitLab/Gitea) are supplying vendors and
they can introduce drastic business changes overtime to the point where we can
terminate their supplying services.

Hence, to prevent vendor lock-in problem, we are:

1. use the native `git` functionalities to maintain the source codes; WHILE
2. only use the GVCS to facilitate mirror-ed hosting and communications only.

In any cases, we do not mind losing the forum but we are very agitated if the
repository maintenance works are unnecessarily being threatened by a known and
identified supply-chain threat.




# What is Required in Your Commit Messages
**Write the whole ESSAY of the issue ticket you are working on**. Remember the
goal is to capture your commitment from problem to why we should apply your
patch.

A format template is as follows:

```
<component ID>: <subject title>        # **REQUIRED**: max 65 characters
                                       # **REQUIRED**: LEAVE THIS EMPTY new LINE
[1st Para: explain the issue problem]  # **REQUIRED**: explain the problem
                                       # presented by the issue ticket. It's a
                                       # paragraph, so use as long as you want.
                                       #
                                       # line should wrap at MAX 80 characters.
                                       #
                                       # If can, include the submitted
                                       # data problems (e.g. log data).
                                       #
                                       # Mentions about the severity of the
                                       # problem (e.g. workaround? critical?).
                                       # See applied labels.
                                       #
                                       # **REQUIRED**: LEAVE THIS EMPTY new LINE
[2nd Para: explain this patch's work]  # Only explains what this patch does for
                                       # its approach to solve the problem
                                       # you mentioned above. It's a
                                       # paragraph, so use as long as you want.
                                       #
                                       # line should wrap at MAX 80 characters.
                                       #
                                       # **REQUIRED**: leave THIS empty new line
Signed-off-by: [NAME] <[EMAIL]>        # **REQUIRED**: Your git signature here.
```

You can refer to the `git log` for inspirations or just ask us in the issue
ticket you're working on.

Note that:

1. You **DO NOT NEED** to explain how the codes work or what are the
files involved. The patch already presented the data.
2. If your effort involves some kind of algorithm explaination, make sure to
include its documentations and mentions where to find them so that your
reviewers know where to digest them.




## GPG Signature for Commit Signature
**Optional but highly recommended** since we are doing manual code-review and
automated CI testing internally on our side with our own automation tools.

If you're signing, please provide your public key source so that we can verify
you internally in the future.




# To Generate Patches
To create your patches, please use any of the following `git` command:

```bash
$ git format-patch <STARTING_COMMID_ID>..<END_COMMID_ID>
```

> Example:
>
> `$ git format-patch fed1235..ab32123`
> `$ git format-patch HEAD~3..HEAD`

This is recommended since:

1. The smaller, single-purpose of the patches, the easier to review and accept.

**OR Alternatively**

```bash
$ git format-patch <STARTING_COMMIT_ID>^..<END_COMMIT_ID> --stdout > my.patch
```

> Example:
>
> `$ git format-patch fed1235^..ab32123 --stdout > my.patch`




# Epilogue
That's all from us. Your pull request **SHALL BE REJECTED WITH PERJUDICE** if
you choose to ignore this message.

Thank you for your cooperation.
