document.addEventListener('DOMContentLoaded', function () {
    const commentsContainer = document.querySelector('.comments-content');
    if (commentsContainer) {
        window.scrollTo(0, 0);
    }

    document.body.classList.add('comments-page');
});

function clearForm() {
    const textarea = document.getElementById('body');
    if (textarea) {
        textarea.value = '';
        textarea.focus();
    }
}

function trackLoginClick(provider) {
    if (window.dataLayer) {
        window.dataLayer.push({
            'event': 'login_button_click',
            'provider': provider,
            'page_location': '/comments'
        });
    }
}

function trackLogoutClick() {
    if (window.dataLayer) {
        window.dataLayer.push({
            'event': 'logout_button_click',
            'page_location': '/comments'
        });
    }
}

const commentForm = document.getElementById('commentForm');
if (commentForm) {
    commentForm.addEventListener('submit', function (e) {
        const commentText = this.querySelector('textarea[name="body"]')?.value;
        if (window.dataLayer) {
            window.dataLayer.push({
                'event': 'comment_submit',
                'comment_length': commentText ? commentText.length : 0,
                'page_location': '/comments'
            });
        }

        const submitBtn = this.querySelector('button[type="submit"]');
        if (submitBtn) {
            const originalText = submitBtn.innerHTML;
            submitBtn.innerHTML = 'Sending...';
            submitBtn.disabled = true;

            setTimeout(() => {
                submitBtn.innerHTML = originalText;
                submitBtn.disabled = false;
            }, 3000);
        }
    });
}

const textarea = document.getElementById('body');
if (textarea) {
    textarea.addEventListener('input', function () {
        this.style.height = 'auto';
        const newHeight = Math.min(this.scrollHeight, 200);
        this.style.height = newHeight + 'px';
    });
}