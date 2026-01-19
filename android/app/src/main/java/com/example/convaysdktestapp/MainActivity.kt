package com.example.convaysdktestapp

import android.net.Uri
import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.activity.enableEdgeToEdge
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.material3.Button
import androidx.compose.material3.OutlinedTextField
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import com.example.convaysdktestapp.ui.theme.ConvaySdkTestAppTheme
import org.synesisit.convay.sdk.ConvayMeet
import org.synesisit.convay.sdk.ConvayMeetActivity
import org.synesisit.convay.sdk.ConvayMeetConferenceOptions
import org.synesisit.convay.sdk.ConvayMeetUserInfo
import java.net.URL

class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        enableEdgeToEdge()
        setContent {
            ConvaySdkTestAppTheme {
                Scaffold(modifier = Modifier.fillMaxSize()) { innerPadding ->
                    JoinMeetingScreen(
                        onJoinClick = { meetingLink -> joinMeeting(meetingLink) },
                        onStartClick = { token -> startMeeting(token) },
                        modifier = Modifier.padding(innerPadding)
                    )
                }
            }
        }
    }

    private fun joinMeeting(meetingLink: String) {
        try {
            // Trim and validate meeting link - ensure value is set first
            val trimmedLink = meetingLink.trim()

            if (trimmedLink.isBlank()) {
                android.util.Log.e(
                    "ConvaySDK",
                    "Join Meeting - Meeting link is empty, cannot launch"
                )
                return
            }

            android.util.Log.d("ConvaySDK", "Join Meeting - Setting meeting link: $trimmedLink")

            // Create user info with display name
            val userInfo = ConvayMeetUserInfo().apply {
                displayName = "Mr Mac"
            }

            // Build options object for joining the conference - ensure meeting link is set first
            val builder = ConvayMeetConferenceOptions.Builder()
                .setMeetingLink(trimmedLink)  // required
                .setUserInfo(userInfo) // optional
                .setFeatureFlag("joinpage.enabled", true) //required
            // Settings for audio and video
            //.setAudioMuted(true)
            //.setVideoMuted(true)

            val options = builder.build()

            // Verify the meeting link was set in options before launching
            android.util.Log.d(
                "ConvaySDK",
                "Join Meeting - Options built with meeting link: $trimmedLink"
            )
            android.util.Log.d("ConvaySDK", "Join Meeting - Launching SDK now...")

            // Launch the new activity with the given options. The launch() method takes care
            // of creating the required Intent and passing the options.
            ConvayMeetActivity.launch(this, options)
        } catch (e: Exception) {
            android.util.Log.e("ConvaySDK", "Error opening Convay Meet SDK", e)
            e.printStackTrace()
        }
    }

    private fun startMeeting(authToken: String) {
        try {
            val trimmedToken = authToken.trim()
            if (trimmedToken.isBlank()) {
                android.util.Log.e("ConvaySDK", "Start Meeting - Token is empty, cannot launch")
                return
            }

            val builder = ConvayMeetConferenceOptions.Builder()
                .setToken(trimmedToken)  // required
                .setFeatureFlag("startpage.enabled", true) // required
//                .setFeatureFlag("toolbox.enabled", true)
//                .setFeatureFlag("filmstrip.enabled", true)
//                .setFeatureFlag("chat.enabled", true)
//                .setFeatureFlag("recording.enabled", true)
                // Audio and video settings
//                .setAudioMuted(false)
//                .setVideoMuted(false)

            val options = builder.build()

            // Verify the meeting link was set in options before launching
            android.util.Log.d("ConvaySDK", "Start Meeting - Options built with meeting link: ")
            android.util.Log.d("ConvaySDK", "Start Meeting - Launching SDK now...")

            // Launch the activity with the new options
            ConvayMeetActivity.launch(this, options)
        } catch (e: Exception) {
            android.util.Log.e("ConvaySDK", "Error starting Convay Meet SDK", e)
            e.printStackTrace()
        }
    }
}

@Composable
fun JoinMeetingScreen(
    onJoinClick: (String) -> Unit,
    onStartClick: (String) -> Unit,
    modifier: Modifier = Modifier
) {
    var meetingLink by remember { mutableStateOf("") }
    val token = "eyJhbGciOiJIUzUxMiJ9.eyJhY2Nlc3NfdG9rZW4iOiJzeXRfYzJGemIzUmxjMkZ5YTJWeVkzTmxNak5oZEdkdFlXbHNMbU52YlFfYUFjWFpwUkxCdVFoRVJLWmFsVlVfMllZZGdHIiwiaXNfb25seV9zc28iOmZhbHNlLCJzdWIiOiJiZTgyNzdmMy1jZTY5LTExZWQtOWE0Yy0wMjQyYWMxMzAwMDgiLCJkYXRhIjp7ImZlYXR1cmVzIjpbIlJlY29yZGluZyIsIkRlc2t0b3BBcHAiLCJUcmFuc2NyaXB0aW9uIiwiQ2hhdCIsIkxpdmVzdHJlYW1pbmciXSwidXNlcl9lbWFpbCI6InNhc290ZXNhcmtlcmNzZTIzQGdtYWlsLmNvbSIsImxpY2Vuc2VfbmFtZSI6IkVudGVycHJpc2UgQVBJIFVzZXIiLCJyb2xlIjoiQWRtaW4iLCJvcmdhbml6YXRpb25faWQiOiJjMmRkOTkxNi1jZTY4LTExZWQtOWE0Yy0wMjQyYWMxMzAwMDgiLCJvcmdhbml6YXRpb25fbmFtZSI6IlN5bmVzaXMgSVQgUExDIiwiSUQiOiJiZTgyNzdmMy1jZTY5LTExZWQtOWE0Yy0wMjQyYWMxMzAwMDgiLCJ2YW5pdHlfdXJsIjpudWxsLCJkaXNwbGF5X25hbWUiOiJTYXJrZXIgUnVtcGEiLCJvcmdhbml6YXRpb25fbG9nbyI6bnVsbCwiaXNfY21fdXNlciI6dHJ1ZX0sImRldmljZV9pZCI6IkZTSEdQTUVSQU0iLCJ1c2VyX2lkIjoiQHNhc290ZXNhcmtlcmNzZTIzYXRnbWFpbC5jb206bWF0cml4LmNvbnZheS5jb20iLCJ3ZWxsX2tub3duIjpudWxsLCJwZXJtaXNzaW9uIjp7InZpZXdfZGFzaGJvYXJkIjp0cnVlLCJlZGl0X2dyb3VwIjp0cnVlLCJ2aWV3X3VzZXIiOnRydWUsInZpZXdfcm9sZSI6dHJ1ZSwidmlld19tZWV0aW5nIjp0cnVlfSwiZXhwIjoxNzY4Nzk5NjUwLCJpYXQiOjE3Njg3OTg3NTAsImhvbWVfc2VydmVyIjoibWF0cml4LmNvbnZheS5jb20ifQ.B7ezo_78qRiyu-1FOfPi9aq2cnwA4VBf0Y4QGAnPDQxUu66ObVh8yBOSSCLtks6eC-IvFCjGnYMynE128hZ2-g"


    Box(
        modifier = modifier.fillMaxSize(),
        contentAlignment = Alignment.Center
    ) {
        Column(
            horizontalAlignment = Alignment.CenterHorizontally,
            verticalArrangement = Arrangement.spacedBy(16.dp),
            modifier = Modifier
                .fillMaxWidth()
                .padding(32.dp)
        ) {
            Text(
                text = "Convay Meet SDK Test",
                modifier = Modifier.padding(bottom = 16.dp)
            )

            OutlinedTextField(
                value = meetingLink,
                onValueChange = {
                    meetingLink = it
                    android.util.Log.d("ConvaySDK", "Meeting link updated: $it")
                },
                label = { Text("Meeting Link") },
                placeholder = { Text("Enter meeting link URL") },
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(horizontal = 16.dp)
            )

            // Debug: Show current value (can be removed later)
            if (meetingLink.isNotBlank()) {
                Text(
                    text = "Current: ${meetingLink.take(50)}${if (meetingLink.length > 50) "..." else ""}",
                    modifier = Modifier.padding(horizontal = 16.dp)
                )
            }

            Button(
                onClick = {
                    onStartClick(token)
                },
                enabled = true,
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(horizontal = 16.dp)
            ) {
                Text("Start")
            }

            Button(
                onClick = {
                    val linkValue = meetingLink.trim()
                    android.util.Log.d(
                        "ConvaySDK",
                        "Join button clicked - Current link value: '$linkValue'"
                    )

                    // Ensure value is set before calling
                    if (linkValue.isNotBlank()) {
                        android.util.Log.d(
                            "ConvaySDK",
                            "Join button - Value is valid, launching SDK..."
                        )
                        onJoinClick(linkValue)
                    } else {
                        android.util.Log.e(
                            "ConvaySDK",
                            "Join button - Value is empty, cannot launch"
                        )
                    }
                },
                enabled = meetingLink.trim().isNotBlank(),
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(horizontal = 16.dp)
            ) {
                Text("Join")
            }
        }
    }
}

@Preview(showBackground = true)
@Composable
fun JoinMeetingScreenPreview() {
    ConvaySdkTestAppTheme {
        JoinMeetingScreen(
            onJoinClick = { },
            onStartClick = { }
        )
    }
}