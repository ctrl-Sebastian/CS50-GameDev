using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class GrabPickups : MonoBehaviour {
	private AudioSource pickupSoundSource;
	bool firstHit;
	void Awake() {
		pickupSoundSource = DontDestroy.instance.GetComponents<AudioSource>()[1];
	}

	void Update() {
		firstHit = true;
		if(transform.position.y < -10){
			MazeCounter.mazeCounter = 0;
			LevelGenerator.numHoles = 4;
			DontDestroy.instance.GetComponents<AudioSource>()[0].Stop();
			SceneManager.LoadScene("GameOver");
		}
	}

	void OnControllerColliderHit(ControllerColliderHit hit) {
		if(firstHit){
			if (hit.gameObject.tag == "Pickup") {
				pickupSoundSource.Play();
				LevelGenerator.numHoles = 4;

				SceneManager.LoadScene("Play");
				MazeCounter.mazeCounter += 1;
			}
			firstHit = false;
		}
		else {
			return;
		}
	}
}
