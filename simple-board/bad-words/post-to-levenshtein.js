import http from 'k6/http';
import {check} from 'k6';
import {SharedArray} from 'k6/data';

const textData = new SharedArray('taboo words from txt', function () {
    return open('./WordData.txt', 'r')
        .split('\n')
        .map(word => word.trim())
        .filter(word => word.length > 0);
});
const jsonData = JSON.parse(open('./lang.json')).words;

const data = new SharedArray('taboo words', function () {
    return textData.concat(jsonData);
});

export default function () {
    let cnt = 0;
    data.forEach(word => {
        const payload = JSON.stringify({content: word});
        const params = {headers: {'Content-Type': 'application/json'}};

        let res;
        let success = false;

        while (!success) {
            res = http.post('http://localhost:3000/api/v1/levenshtein', payload, params);
            success = check(res, {
                'is status 201 or 406': (r) => r.status === 201 || r.status === 406,
            });

            if (!success) {
                console.log(`Retrying for word: ${word}`);
            } else {
                cnt++;
            }
        }

        console.log(`Sent word: ${word}, Response: ${res.status} ${res.status_text}`);
    });
    console.log(`Sent ${cnt} words`);
}
