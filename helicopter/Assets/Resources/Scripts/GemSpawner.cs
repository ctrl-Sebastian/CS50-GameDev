using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GemSpawner : MonoBehaviour
{
    public GameObject Gem;
    // Start is called before the first frame update
    void Start()
    {
        // infinite gem spawning function, asynchronous
		StartCoroutine(SpawnGems());
    }

    // Update is called once per frame
    void Update()
    {
        
    }

    IEnumerator SpawnGems() {
		while (true) {

			// number of gems we could spawn vertically
			int gemsThisRow = 1;

			// instantiate all coins in this row separated by some random amount of space
			for (int i = 0; i < gemsThisRow; i++) {
				Instantiate(Gem, new Vector3(26, Random.Range(-10, 10), 10), Quaternion.identity);
			}

			// pause 1-5 seconds until the next coin spawns
			yield return new WaitForSeconds(Random.Range(1, 15));
		}
	}
}
