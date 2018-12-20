import os
import sys

from jinja2 import Template

# base/tests
dir_path = os.path.dirname(os.path.realpath(__file__))

# base
base_path = os.path.dirname(dir_path)


if __name__ == '__main__':
    formula_name = sys.argv[1]
    image_tag = sys.argv[2]

    template = Template(
        open(os.path.join(dir_path, 'templates', 'Dockerfile.j2')).read()
    )

    dockerfile = template.render({
        'formula_name': formula_name,
        'image_tag': image_tag
    })

    with open(os.path.join(base_path, 'Dockerfile.{}'.format(image_tag)), 'w') as fh:
        fh.write(dockerfile)
