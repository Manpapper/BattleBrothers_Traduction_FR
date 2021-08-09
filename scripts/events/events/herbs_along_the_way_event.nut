this.herbs_along_the_way_event <- this.inherit("scripts/events/event", {
	m = {
		Volunteer = null,
		OtherGuy = null
	},
	function create()
	{
		this.m.ID = "event.herbs_along_the_way";
		this.m.Title = "Sur la route...";
		this.m.Cooldown = 30.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "%terrainImage%Alors que vous vous dirigez vers votre destination, %volunteer% se précipite vers vous avec un paquet d\'herbes à la main. Vous savez que cet idiot ne connaît rien aux plantes ou à la vie sauvage, mais il semble plutôt persistant à vouloir les essayer. Il parle d\'\"entendre\" les pouvoirs magiques que l\'on peut trouver dans l\'essence des herbes. Cette conversation attire l\'attention de quelques autres personnes de la compagnie. Bientôt, un certain nombre d\'entre eux demandent à essayer la \"médecine\" pour le bien de leurs frères d\'armes.",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Ils ont l\'air sympas, des volontaires pour les essayer ?",
					function getResult( _event )
					{
						return this.Math.rand(1, 100) <= 50 ? "C" : "B";
					}

				},
				{
					Text = "{Mieux vaut ne pas tenter notre chance. | Vous ne ferez que vous empoisonner vous-mêmes, bande d\'idiots.}",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "%terrainImage%Il semble que les herbes ne soient pas seulement inoffensives, mais qu\'elles aient même des vertus curatives chez certains problèmes récurrents de vos hommes. Le rhume de %volunteer% semble s\'être dissipé et les douleurs d\'estomac de %otherguy% se sont atténuées. Après avoir essayé vous-même, vous voyez une écharde s\'échapper de votre pouce. Incroyable !",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Incroyable!",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local amount = this.Math.rand(5, 12);
				this.World.Assets.addMedicine(amount);
				this.List = [
					{
						id = 10,
						icon = "ui/icons/asset_medicine.png",
						text = "Vous recevez [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + amount + "[/color] de Ressources Médicales"
					}
				];
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_18.png[/img]D\'un bout vient le vomi et de l\'autre la merde. Il semble que les herbes ne valaient pas la peine d\'être essayées après tout. %volontaire% s\'est courageusement déclaré prêt à engloutir les plantes mystérieuses et, il suffit de le dire, les proportions que vous voyez sortir de lui sont définitivement mystiques dans le sens large du terme, \"le corps peut-il vraiment en contenir autant ?\".",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Beurk.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local effect = this.new("scripts/skills/injury/sickness_injury");
				_event.m.Volunteer.getSkills().add(effect);
				this.List = [
					{
						id = 10,
						icon = effect.getIcon(),
						text = _event.m.Volunteer.getName() + " est malade"
					}
				];
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.World.getTime().IsDaytime)
		{
			return;
		}

		local currentTile = this.World.State.getPlayer().getTile();

		if (currentTile.Type != this.Const.World.TerrainType.Forest && currentTile.Type != this.Const.World.TerrainType.LeaveForest && currentTile.Type != this.Const.World.TerrainType.Swamp)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 3)
		{
			return;
		}

		local candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getHitpoints() > 20 && !bro.getSkills().hasSkill("injury.sickness") && !bro.getSkills().hasSkill("trait.bright") && !bro.getSkills().hasSkill("trait.hesitant"))
			{
				candidates.push(bro);
			}
		}

		if (candidates.len() > 0)
		{
			this.m.Volunteer = candidates[this.Math.rand(0, candidates.len() - 1)];
			this.m.Score = 10;

			do
			{
				local bro = brothers[this.Math.rand(0, brothers.len() - 1)];

				if (bro.getID() != this.m.Volunteer.getID())
				{
					this.m.OtherGuy = bro;
				}
			}
			while (this.m.OtherGuy == null);
		}
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		local currentTile = this.World.State.getPlayer().getTile();
		local image;

		if (currentTile.Type == this.Const.World.TerrainType.Swamp)
		{
			image = "[img]gfx/ui/events/event_09.png[/img]";
		}
		else
		{
			image = "[img]gfx/ui/events/event_25.png[/img]";
		}

		_vars.push([
			"volunteer",
			this.m.Volunteer.getName()
		]);
		_vars.push([
			"otherguy",
			this.m.OtherGuy.getName()
		]);
		_vars.push([
			"image",
			image
		]);
	}

	function onDetermineStartScreen()
	{
		return "A";
	}

	function onClear()
	{
		this.m.Volunteer = null;
		this.m.OtherGuy = null;
	}

});

