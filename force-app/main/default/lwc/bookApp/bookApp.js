import { LightningElement, track } from 'lwc';

const API_KEY = 'AIzaSyCeD3kfIySvIY_E-MiJaop5jwstZuDSToE'; // Replace with your YouTube API Key

export default class YoutubeSearch extends LightningElement {
    @track searchQuery = 'New Hindi Songs';
    @track videos = [];
    @track isLoading = false;
    @track selectedVideoId = null;

    // Fetch YouTube results when component loads
    connectedCallback() {
        this.handleSearch(this.searchQuery);
    }

    handleInputChange(event) {
        this.searchQuery = event.target.value;
        // Clear any existing timer
        clearTimeout(this.debounceTimer);

        // Set a new timer to delay the API call
        this.debounceTimer = setTimeout(() => {
            this.handleSearch(this.searchQuery);
        }, 1000); // Adjust delay as needed (500ms)
    }

    async handleSearch(query) {
        if (!this.searchQuery) return;

        this.isLoading = true;

        try {
            const response = await fetch(`https://www.googleapis.com/youtube/v3/search?part=snippet&q=${encodeURIComponent(query)}&type=video&key=${API_KEY}&maxResults=50`);
            const data = await response.json();

            this.videos = data.items.map(item => ({
                videoId: item.id.videoId,
                title: item.snippet.title,
                thumbnail: item.snippet.thumbnails.high.url,
                channelTitle: item.snippet.channelTitle
            }));
        } catch (error) {
            console.error('Error fetching YouTube videos:', error);
        }

        this.isLoading = false;
    }

    handleVideoClick(event) {
        this.selectedVideoId = event.currentTarget.dataset.videoId;
    }

    get embeddedVideoUrl() {
        return this.selectedVideoId ? `https://www.youtube.com/embed/${this.selectedVideoId}?autoplay=1` : '';
    }

    closeVideo() {
        this.selectedVideoId = null;
    }
}

