#pragma once
#include "Common.h"
#include <Node.hpp>
#include <MultiMeshInstance2D.hpp>
#include <MultiMesh.hpp>
#include <PoolArrays.hpp>
#include "Bullet.h"
#include "Item.h"
#include "CurveLaser.h"
#include <SurfaceTool.hpp>
#include <Array.hpp>


class BulletRender : public Node
{
	GODOT_CLASS(BulletRender, Node);

	NodePath BulletsPath = NodePath();

	NodePath BulletRendererPath = NodePath();
	NodePath BulletRendererUpperPath = NodePath();
	NodePath BulletRendererAddPath = NodePath();
	NodePath BulletClearPath = NodePath();
	NodePath ItemRendererPath = NodePath();
	NodePath ItemTextRendererPath = NodePath();

	Node* Bullets = nullptr;

	Ref<MultiMesh> BulletRendererMesh;
	Ref<MultiMesh> BulletRendererUpperMesh;
	Ref<MultiMesh> BulletRendererAddMesh;
	Ref<MultiMesh> BulletClearMesh;
	Ref<MultiMesh> ItemRendererMesh;
	Ref<MultiMesh> ItemTextRendererMesh;


	float s(float t);

public:
	static void _register_methods();
	void _init();

	void _ready();
	void _process(float delta);

};

