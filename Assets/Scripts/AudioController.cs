using System.Collections;
using System.Collections.Generic;
using UnityEngine;
public class AudioController : MonoBehaviour
{
    public static AudioController aCtrl;
    public GameObject bgMusic1;
    public AudioSource sfxSrc;
    private AudioSource levelMusic;

    public void Awake()
    {
        if (aCtrl == null)
        {
            levelMusic = bgMusic1.GetComponent<AudioSource>();
            levelMusic.loop = true;
            aCtrl = this;
        }
    }

    public void PlaySFX()
    {
        //aCtrl.sfxSrc.Play() //this does the same thing
        sfxSrc.Play();
    }
    public void StopMusic()
    {
        levelMusic.Stop();
    }
    public void PauseMusic()
    {
        levelMusic.Pause();
    }
    public void PlayMusic()
    {
        levelMusic.Play();
    }

    //more functions to dynamically add new sounds
}