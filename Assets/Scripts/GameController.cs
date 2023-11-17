using UnityEngine;
using System;
using System.Runtime.Serialization.Formatters.Binary;
using System.IO;
public class GameController : MonoBehaviour
{
    public int highScore = 0;
    const string fileName = "/highscore.dat";
    public static GameController gCtrl;

    public void Awake()
    {
        if (gCtrl == null)
        {
            DontDestroyOnLoad(gameObject);
            gCtrl = this;
            LoadScore();
        }
    }

    public void LoadScore()
    {
        if (File.Exists(Application.persistentDataPath + fileName))
        {
            BinaryFormatter bf = new BinaryFormatter();
            FileStream fs = File.Open(Application.persistentDataPath + fileName, FileMode.Open, FileAccess.Read);
            GameData data = (GameData)bf.Deserialize(fs);
            fs.Close();
            gCtrl.highScore = data.score;
        }
    }

    public void SaveScore(int score)
    {
        if (score > gCtrl.highScore)
        {
            gCtrl.highScore = score;
            BinaryFormatter bf = new BinaryFormatter();
            FileStream fs = File.Open(Application.persistentDataPath + fileName, FileMode.OpenOrCreate);
            GameData data = new GameData();
            data.score = score;
            bf.Serialize(fs, data);
            fs.Close();
        }
    }

    public int GetCurrentScore()
    {
        return PlayerPrefs.GetInt("CurrentScore");
    }
    public void SetCurrentScore(int num)
    {
        PlayerPrefs.SetInt("CurrentScore", num);
    }

    public void AddScorePressed()
    {
        int score = GetCurrentScore();
        score++;
        SetCurrentScore(score);
        SaveScore(score);
    }
    public void MinusScorePressed()
    {
        int score = GetCurrentScore();
        score--;
        SetCurrentScore(score);
    }

}

[Serializable]
class GameData
{
    public int score;

}
