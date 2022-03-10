this.deserter_origin_volunteer_event <- this.inherit("scripts/events/event", {
	m = {
		Dude1 = null,
		Dude2 = null,
		Victim = null
	},
	function create()
	{
		this.m.ID = "event.deserter_origin_volunteer";
		this.m.Title = "Sur la route...";
		this.m.Cooldown = 50.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_88.png[/img]{Deux hommes à l'air ébouriffé et fatigué sortent des buissons au bord de la route. Ils lèvent les mains comme s'ils venaient se rendre.%SPEECH_ON%Êtes-vous %companyname% ? On nous a dit que vous étiez une bande de déserteurs. Et je ne dis pas ça comme une insulte. Nous sommes aussi des fuyards, mais nous n'avons nulle part où aller. Partout où nous allons, il y a des chasseurs de primes et des bourreaux. Laissez-nous nous battre pour vous. Ce n'est pas le combat qui nous a fait peur, on le jure.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Nous pourrions utiliser des combattants comme vous.",
					function getResult( _event )
					{
						return this.Math.rand(1, 100) <= 60 ? "B" : "C";
					}

				},
				{
					Text = "Nous n'avons pas besoin de vous.",
					function getResult( _event )
					{
						this.World.getTemporaryRoster().clear();
						_event.m.Dude1 = null;
						_event.m.Dude2 = null;
						return 0;
					}

				}
			],
			function start( _event )
			{
				local roster = this.World.getTemporaryRoster();
				_event.m.Dude1 = roster.create("scripts/entity/tactical/player");
				_event.m.Dude1.setStartValuesEx([
					"deserter_background"
				]);
				_event.m.Dude1.getBackground().m.RawDescription = "Fuyant les chasseurs de primes et les bourreaux depuis un certain temps, %name% est tombé sur votre compagnie sur la route et a immédiatement demandé à vous rejoindre.";
				_event.m.Dude1.getBackground().buildDescription(true);
				_event.m.Dude2 = roster.create("scripts/entity/tactical/player");
				_event.m.Dude2.setStartValuesEx([
					"deserter_background"
				]);
				_event.m.Dude2.getBackground().m.RawDescription = "%name% a déserté un régiment de l'armée avec " + _event.m.Dude1.getNameOnly() + " avant qu'il ne demande de vous rejoindre.";
				_event.m.Dude2.getBackground().buildDescription(true);
				this.Characters.push(_event.m.Dude1.getImagePath());
				this.Characters.push(_event.m.Dude2.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_88.png[/img]{Il serait presque satisfaisant et ironique de pendre ces hommes pour ce qu'ils ont fait, mais vous n'êtes pas prêt à donner ce message à la compagnie. Vous les accueillez dans le groupe et les envoyez à l'inventaire. %victim% garde un œil sur eux pendant un certain temps, mais il rapporte que les hommes sont fidèles à leur parole et vont se battre.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Bienvenue dans %companyname% !",
					function getResult( _event )
					{
						this.World.getPlayerRoster().add(_event.m.Dude1);
						this.World.getPlayerRoster().add(_event.m.Dude2);
						this.World.getTemporaryRoster().clear();
						_event.m.Dude1.onHired();
						_event.m.Dude2.onHired();
						_event.m.Dude1 = null;
						_event.m.Dude2 = null;
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Dude1.getImagePath());
				this.Characters.push(_event.m.Dude2.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_05.png[/img]{Il serait presque satisfaisant et ironique de pendre ces hommes pour ce qu'ils ont fait, mais vous n'êtes pas prêt à donner ce message à la compagnie. Vous les accueillez dans le groupe, les envoyant à l'inventaire avec %victim% qui garde un œil sur eux. Sauf que vous ne voyez pas votre mercenaire pendant un laps de temps. Lorsque vous partez à sa recherche, il est retrouvé assommé sur le sol et l'inventaire saccagé. Les deux hommes sont introuvables !}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Maudits soient ces salauds !",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.getTemporaryRoster().clear();
				_event.m.Dude1 = null;
				_event.m.Dude2 = null;
				local injury = _event.m.Victim.addInjury(this.Const.Injury.Concussion);
				this.List.push({
					id = 10,
					icon = injury.getIcon(),
					text = _event.m.Victim.getName() + " souffre de " + injury.getNameOnly()
				});
				local r = this.Math.rand(1, 4);

				if (r == 1)
				{
					local food = this.World.Assets.getFoodItems();
					food = food[this.Math.rand(0, food.len() - 1)];
					this.World.Assets.getStash().remove(food);
					this.List.push({
						id = 10,
						icon = "ui/items/" + food.getIcon(),
						text = "Vous perdez " + food.getName()
					});
				}
				else if (r == 2)
				{
					local amount = this.Math.rand(20, 50);
					this.World.Assets.addAmmo(-amount);
					this.List.push({
						id = 10,
						icon = "ui/icons/asset_ammo.png",
						text = "Vous perdez  [color=" + this.Const.UI.Color.NegativeEventValue + "]-" + amount + "[/color] de Munitions"
					});
				}
				else if (r == 3)
				{
					local amount = this.Math.rand(5, 10);
					this.World.Assets.addArmorParts(-amount);
					this.List.push({
						id = 10,
						icon = "ui/icons/asset_supplies.png",
						text = "Vous perdez  [color=" + this.Const.UI.Color.NegativeEventValue + "]-" + amount + "[/color] d'Outils"
					});
				}
				else if (r == 4)
				{
					local amount = this.Math.rand(5, 10);
					this.World.Assets.addMedicine(-amount);
					this.List.push({
						id = 10,
						icon = "ui/icons/asset_medicine.png",
						text = "Vous perdez  [color=" + this.Const.UI.Color.NegativeEventValue + "]-" + amount + "[/color] de Ressources Médicales"
					});
				}

				this.Characters.push(_event.m.Victim.getImagePath());
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Wildmen)
		{
			return;
		}

		if (this.World.Assets.getOrigin().getID() != "scenario.deserters")
		{
			return;
		}

		local currentTile = this.World.State.getPlayer().getTile();

		if (!currentTile.HasRoad)
		{
			return;
		}

		if (this.World.getPlayerRoster().getSize() + 1 >= this.World.Assets.getBrothersMax())
		{
			return;
		}

		local roster = this.World.getPlayerRoster().getAll();
		this.m.Victim = roster[this.Math.rand(0, roster.len() - 1)];
		this.m.Score = 20;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"victim",
			this.m.Victim.getName()
		]);
	}

	function onClear()
	{
		this.m.Dude1 = null;
		this.m.Dude2 = null;
		this.m.Victim = null;
	}

});

