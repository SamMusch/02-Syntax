# API

## Code

```python
url = 'https://api.github.com/repos/pandas-dev/pandas/issues'
resp = requests.get(url)
data = resp.json()          # Returns a DICTIONARY
data[0].keys()              # Available keys
df = pd.DataFrame(data, columns = ['number', 'title', 'labels', 'state'])
```



## Overview

[Paper](https://www.immagic.com/eLibrary/ARCHIVES/GENERAL/WIKIPEDI/W120623A.pdf)

Application programming interface = API

[Link]([https://www.basicknowledge101.com/pdf/km/Application%20programming%20interface.pdf](https://www.basicknowledge101.com/pdf/km/Application programming interface.pdf)): API = set of routines, protocols, tools for building software apps



## Intro - Brian Cookey

### 1. Intro

Person   -   server (API)   -   computer

Resources = the "nouns" of APIs

Client / Server

- Server - nothing more than a powerful computer. Waits for our request and then performs
  - Provides the API

- Client - talks to the server, gets the data we need
- API - the tool that makes the website's data digestible for a computer
  - Just a set of rules that both sides agree to

---

### 2. Protocols

Protocol - the "etiquette" that the 2 sides use when communicating

HTTP - main web protocol. To make a valid request, client needs to include:

- URL
- Method
  - GET (retrieve)
  - POST (create new)
  - PUT (edit)
  - DELETE
- List of headers
  - Provides meta info. (What time, size of body, etc)
- Body
  - Contains the data that we want

When the server responds, it sends a 3-digit number instead of the URL / Method. This would be something like 404 (not found), 200 (success). The "list of headers" and the "body" remain the same.

*Begin able to use an API relies on understanding how to make correct HTTP requests to the server.*

---

### 3. Data Formats



JSON

- Keys - represent an *attribute* of an object. Also have a corresponding value.
- Associated Array - nested object, lets you use an object as the value for some key



XML - Exstensible markup language

- First part of the block is called a *root node*
- Inside we have *parent* and *child* nodes



How data formats are used in HTTP

- Headers
  - *Content-type* is where we specify data format
  - *Accept* is how the client asks the server what formats it can read

---

### 4 - 5. Authentication

How does the server know that the client is who it says it is?

- Authentification



Authentification schemes

- Basic - requires username and password
  - Part of the *Header* that is passed
- API Key Auth - requires API to be accessed with a *unique key*
  - Sometimes this key is used instead of the *username & password* 
  - Sometimes you add it to the *url*
  - Sometimes its somewhere in the *body*
- Open Authorization (OAuth)
  - Automates the key exchange to make things easier for us
  - Requires user to give *username & password*, does the API key stuff behind the scenes
    - OAuth 1 - (pg 42)
    - OAuth 2 - Tries to make it easy for companies to adapt the auth process to their needs. Might be slight differences. Gives us the ability to set an expire time on the *access token*
      - Step 1 - User tells client to connect to server
      - Step 2 - Client sends the user to the server
      - Step 3 - User signs in to server, grants the client access
      - Step 4 - Clients sends us back to the client along with the unique *auth code*
      - Step 5 - Client sends this *auth code* back to the client. Once the server sees this, it sends the client an *access token*
      - Step 6 - The client can get data from the server

---

### 6. API Design

SOAP - XML based, standardized structure for request & response

#### REST

Representational State Transfer

Lots of conventions but lots of flexibility for designers



---

### 7. Real Time Communication

Client Driven - Need the server to update

Server Driven - Need to client to update

- **Polling** - ask the server for updates
- **Long** **polling** - same, but the server doesn't respond until something changes
- **Webhooks** - client makes requests & listens for requests. This makes the client a server as well.
  - Client has to provide *callback url*
  - Server has to have a place for someone enter the *callback url*
  - When something changes on server, server sends **request** to the client to let it know
- **Subscription webhooks** - makes it so that a person doesn't have to enter the *callback url*, just happens automatically
  - Example: REST Hooks
  - Client: "Let me know if anything changes"
  - Server: "Okay"



---



## CS50

[Main Lecture](https://www.youtube.com/watch?v=24Kf3v7kZyE), [Beyond](youtube.com/watch?v=hrWlXsx48Ss&list=LLiv6JOoOHlxzSCYoarMOUzA&index=2&t=8s)





# Webscrape

```python
def total_consumer_credit():
    r = urllib.request.urlopen('https://www.federalreserve.gov/releases/g19/current/default.htm')
    soup = BeautifulSoup(r)

    t = soup.find('table', title='Consumer Credit Outstanding')
    headers = t.thead.find_all('tr')
    labels = []

    for l in headers[1].find_all('th'):
        labels.append(l.get_text())

    rows = t.tbody.find_all('tr')

    index = []
    data = []

    for r in rows[7:9]:
        index.append(r.th.get_text().strip())
        td = r.find_all('td')
        row_list = []
        for i in range(len(labels)):
            v = td[i].get_text().strip().replace(',', '')
            row_list.append(float(v))
        data.append(row_list)

    # Create the DataFrame
    return pd.DataFrame(data, index=index, columns=labels)


```























