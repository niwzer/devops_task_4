import shutil
from pathlib import Path

from django.conf import settings
from django.core.management import call_command
from django.core.management.base import BaseCommand


class Command(BaseCommand):
    help = "Prepare a deployable application directory."

    def handle(self, *args, **options):
        base_dir = Path(settings.BASE_DIR)
        build_dir = base_dir / "build"

        call_command("check")
        call_command("collectstatic", interactive=False, clear=True)

        if build_dir.exists():
            shutil.rmtree(build_dir)
        build_dir.mkdir()

        ignore = shutil.ignore_patterns("__pycache__", "*.pyc")

        for folder in ("core", "demo", "templates", "static_in_env"):
            shutil.copytree(
                base_dir / folder,
                build_dir / folder,
                ignore=ignore,
            )

        shutil.copytree(
            Path(settings.STATIC_ROOT),
            build_dir / "static_root",
        )

        for filename in ("manage.py", "requirements.txt"):
            shutil.copy2(base_dir / filename, build_dir / filename)

        self.stdout.write(self.style.SUCCESS("Build created in build/"))