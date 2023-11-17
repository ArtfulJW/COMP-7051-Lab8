using UnityEngine;
using TMPro;
using UnityEngine.UI;

public class Score : MonoBehaviour
{
    public Text text;
    // Update is called once per frame
    void Update()
    {
        text.text = "Score: " + GameController.gCtrl.GetCurrentScore();
    }
}