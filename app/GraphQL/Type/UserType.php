<?php
namespace App\GraphQL\Type;

use GraphQL;
use GraphQL\Type\Definition\Type;
use Folklore\GraphQL\Support\Type as GraphQLType;
use App\GraphQL\Type\UserType;

class UserType extends GraphQLType
{
    protected $attributes = [
        'name' => 'User',
        'description' => 'A user'
    ];

    public function fields()
    {
        return [
            'id' => [
                'type' => Type::nonNull(Type::int()),
                'description' => 'The id of the user'
            ],
            'name' => [
                'type' => Type::string(),
                'description' => 'The name of user'
            ],
            'email' => [
                'type' => Type::string(),
                'description' => 'The email of user'
            ],
            'friends' => [
                'type' => Type::listOf(GraphQL::type('User')),
                'description' => 'The friends of user'
            ],
        ];
    }

    protected function resolveNameField($root, $args)
    {
        return $root->name . '(Custom)';
    }

    protected function resolveFriendsField($root, $args)
    {
        return $root->where('id', 3)->get();
    }
}
