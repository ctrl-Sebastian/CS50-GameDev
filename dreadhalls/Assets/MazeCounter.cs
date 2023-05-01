using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class MazeCounter : MonoBehaviour
{
    public static int mazeCounter = 0;
    public Text counter;
    // Start is called before the first frame update
    void Start()
    {
        counter = GetComponent<Text>();
    }

    // Update is called once per frame
    void Update()
    {
        if (mazeCounter > 0) {
			counter.text = "Maze: " + mazeCounter;
		}
    }
}
