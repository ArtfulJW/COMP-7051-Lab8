using UnityEngine;
using TMPro;
using UnityEngine.UI;

public class HighScore : MonoBehaviour
{
    public Text text;
    // Update is called once per frame
    void Update()
    {
        text.text = "High score: " + GameController.gCtrl.highScore;
    }
}