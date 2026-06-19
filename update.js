async function checkForUpdates() {
    const localVersion = "1.0.0";
    const updateUrl = "https://raw.githubusercontent.com/Jim71G/SweetEdition/main/update.json";


    try {
        const response = await fetch(updateUrl, { cache: "no-store" });

        if (!response.ok) {
            console.error("Failed to fetch update info:", response.status);
            return;
        }

        const updateData = await response.json();
        const remoteVersion = updateData.version;

        console.log("Local Version:", localVersion);
        console.log("Remote Version:", remoteVersion);

        if (isNewerVersion(remoteVersion, localVersion)) {
            document.getElementById("local-version").textContent = `${localVersion} → ${remoteVersion}`;
            showUpdateBanner(updateData);
        }



        if (isNewerVersion(remoteVersion, localVersion)) {
            console.log("Update available:", remoteVersion);
            showUpdateBanner(updateData);
        } else {
            console.log("You are on the latest version.");
        }

    } catch (error) {
        console.error("Error checking for updates:", error);
    }
}

// Compare version numbers like 1.0.0 vs 1.0.1
function isNewerVersion(remote, local) {
    const r = remote.split(".").map(Number);
    const l = local.split(".").map(Number);

    for (let i = 0; i < r.length; i++) {
        if (r[i] > l[i]) return true;
        if (r[i] < l[i]) return false;
    }
    return false;
}

// Show update banner on the page
function showUpdateBanner(updateData) {
    const banner = document.createElement("div");
    banner.className = "update-banner";

    banner.innerHTML = `
        <strong>Update Available: v${updateData.version}</strong><br>
        ${updateData.description}<br>
        <a href="${updateData.download_url}" target="_blank">Download Update</a>
    `;

    document.body.prepend(banner);
}

// Run update check on page load
document.addEventListener("DOMContentLoaded", checkForUpdates);
