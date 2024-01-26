this.pirates_event <- this.inherit("scripts/events/event", {
	m = {
		Fisherman = null,
		Dude = null
	},
	function create()
	{
		this.m.ID = "event.pirates";
		this.m.Title = "Sur la route...";
		this.m.Cooldown = 80.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_157.png[/img]{Vous croisez une file d\'hommes enchaînés. Leur chef fait remarquer qu\'ils font partie des endettés, mais l\'un des hommes, manifestement un Nordiste, crie qu\'ils sont des marins marchands qui ont été capturés par des pirates. Le prétendu chasseur d\'hommes à la tête de cette troupe rit. %SPEECH_ON%Ne croyez pas ses mensonges, voyageur, ceux qui sont profondément endettés envers le Doreur craignent le long voyage vers la rédemption. Il préfère mourir et affronter les flammes de l\'enfer plutôt que de se préoccuper de son salut. N\'y a-t-il rien de plus humain que cela?%SPEECH_OFF%}",
			Banner = "",
			List = [],
			Characters = [],
			Options = [],
			function start( _event )
			{
				this.Options.push({
					Text = "Libérez ces hommes immédiatement !",
					function getResult( _event )
					{
						return "B";
					}

				});

				if (_event.m.Fisherman != null)
				{
					this.Options.push({
						Text = "Il semble que %fisherman% ait quelque chose à dire sur le sujet.",
						function getResult( _event )
						{
							return "C";
						}

					});
				}

				if (this.World.Assets.getOrigin().getID() == "scenario.manhunters")
				{
					this.Options.push({
						Text = "Remettez-moi les endettés et je poursuivrai leur salut en conséquence.",
						function getResult( _event )
						{
							return "D";
						}

					});
				}

				this.Options.push({
					Text = "Continuez votre chemin alors, chasseurs d\'hommes.",
					function getResult( _event )
					{
						return "E";
					}

				});
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_157.png[/img]{Vous tirez votre épée et exigez que les endettés soit libéré. Le chasseur d\'homme regarde autour de lui, incrédule.%SPEECH_ON%Voyageur, je ne fais qu\'obéir aux lois du Doreur. Ces hommes ont des dettes à payer, et le feu de l\'enfer attend ceux qui ne s\'exécuteront pas.%SPEECH_OFF%Secouant votre tête, vous lui dites que vous ne vous répéterez pas. Il soupire et commence à détacher les hommes. La plupart partent immédiatement en courant, mais un reste derrière. Mais il n\'est pas là pour vous rejoindre, il reste avec le chasseur d\'hommes, en lui tendant les poignets.%SPEECH_ON%S\'il vous plaît, laissez-moi entrer dans la lumière du Doreur.%SPEECH_OFF%Un autre homme reste également derrière, mais surtout pour se réunir avec vous. Il s\'annonce avec des intentions claires : il va se joindre et se battre pour la %companyname%.%SPEECH_ON%Si j\'ai des dettes à payer, c\'est avec vous, monsieur.%SPEECH_OFF%}",
			Banner = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "J\'espère que vous savez comment utiliser une arme.",
					function getResult( _event )
					{
						this.World.getPlayerRoster().add(_event.m.Dude);
						this.World.getTemporaryRoster().clear();
						_event.m.Dude.onHired();
						_event.m.Dude = null;
						return 0;
					}

				},
				{
					Text = "Tu es libre, mais tu devras retrouver ton chemin tout seul.",
					function getResult( _event )
					{
						this.World.getTemporaryRoster().clear();
						_event.m.Dude = null;
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.Assets.addMoralReputation(2);
				local roster = this.World.getTemporaryRoster();
				_event.m.Dude = roster.create("scripts/entity/tactical/player");
				_event.m.Dude.setStartValuesEx([
					"fisherman_background"
				]);
				_event.m.Dude.setTitle("the Sailor");
				_event.m.Dude.getBackground().m.RawDescription = "Vous avez sauvé %nom% d\'une vie d\'esclavage après qu\'il ait été capturé par des pirates opérant hors des villes états.";
				_event.m.Dude.getBackground().buildDescription(true);
				_event.m.Dude.getItems().unequip(_event.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand));
				_event.m.Dude.getItems().unequip(_event.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Offhand));
				_event.m.Dude.worsenMood(2.0, "Il a été capturé par des chasseurs d\'hommes");
				this.Characters.push(_event.m.Dude.getImagePath());
				local cityStates = this.World.FactionManager.getFactionsOfType(this.Const.FactionType.OrientalCityState);

				foreach( c in cityStates )
				{
					c.addPlayerRelation(this.Const.World.Assets.RelationNobleContractFail, "J\'ai entendu des rumeurs selon lesquelles tu libérerais des endettés");
				}
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_157.png[/img]{%fisherman% le pêcheur s\'avance.%SPEECH_ON%Attendez, je connais cet homme ! Il n\'est redevable à personne, on naviguait ensemble il y a plusieurs hivers.%SPEECH_OFF%Le marin acquiesce.%SPEECH_ON%Oui, oui c\'est vrai!%SPEECH_OFF%Le chasseur d\'homme regarde, puis s\'avance et libère le marin.%SPEECH_ON%Je ne suis pas étranger aux circonstances et aux complexités du Doreur et je peux voir les machinations de ses plans. Il ne fait aucun doute qu\'il voulait que ces deux-là se rencontrent. S\'il vous plaît, prenez l\'homme, et son salut sera vrai.%SPEECH_OFF%Le chasseur d\'homme continue avec son train d\'hommes capturés. L\'un d\'entre eux se tourne vers toi.%SPEECH_ON% C\'est vraiment dommage qu\'on ne se connaisse pas, hein ?%SPEECH_OFF%}",
			Banner = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Bienvenue. J\'espère que vous savez comment utiliser une arme.",
					function getResult( _event )
					{
						this.World.getPlayerRoster().add(_event.m.Dude);
						this.World.getTemporaryRoster().clear();
						_event.m.Dude.onHired();
						_event.m.Dude = null;
						return 0;
					}

				},
				{
					Text = "Tu devras retrouver le chemin de la maison par tes propres moyens.",
					function getResult( _event )
					{
						this.World.getTemporaryRoster().clear();
						_event.m.Dude = null;
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Fisherman.getImagePath());
				this.World.Assets.addMoralReputation(2);
				local roster = this.World.getTemporaryRoster();
				_event.m.Dude = roster.create("scripts/entity/tactical/player");
				_event.m.Dude.setStartValuesEx([
					"fisherman_background"
				]);
				_event.m.Dude.setTitle("the Sailor");
				_event.m.Dude.getBackground().m.RawDescription = "Vous avez sauvé %nom% d\'une vie d\'esclavage après qu\'il ait été capturé par des pirates opérant hors des villes états.";
				_event.m.Dude.getBackground().buildDescription(true);
				_event.m.Dude.getItems().unequip(_event.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand));
				_event.m.Dude.getItems().unequip(_event.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Offhand));
				_event.m.Dude.worsenMood(2.0, "Il a été capturé par des chasseurs d\'hommes");
				_event.m.Dude.improveMood(0.5, "J\'ai été sauvé d\'une vie d\'esclavage par... " + _event.m.Fisherman.getName());
				_event.m.Fisherman.improveMood(2.0, "Saved " + _event.m.Dude.getName() + " from a life in slavery");
				this.Characters.push(_event.m.Dude.getImagePath());
				local cityStates = this.World.FactionManager.getFactionsOfType(this.Const.FactionType.OrientalCityState);

				foreach( c in cityStates )
				{
					c.addPlayerRelation(this.Const.World.Assets.RelationNobleContractFail, "J\'ai entendu des rumeurs selon lesquelles tu libérerais des endettés");
				}
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_157.png[/img]{Vous secouez une chaîne et faites avancer quelques-uns de vos endettés. En montrant votre crédibilité, vous dites au chasseur d\'hommes que vous avez de l\'expérience dans ce domaine et que ces marins indisciplinés trouveront un moment pour lui tendre une embuscade et le tuer.%SPEECH_ON% Remettez-les moi et je poursuivrai leur salut en conséquence. Garde-les à ta place, et le Doreur lui-même ne pourra pas te protéger du mal qui se cache dans leurs cœurs.%SPEECH_OFF%Le chasseur d\'homme réfléchit un moment, puis acquiesce.%SPEECH_ON%Tu as raison. C\'était un bon butin, mais le Doreur verra que mes actes ont déjà été suffisants et mes intentions réelles. Prends-les pour toi et que le Doreur fasse briller la sublimité sur ta vie et la leur.%SPEECH_OFF%}",
			Banner = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Le Doreur est très bienveillant de vous laisser payer votre dette.",
					function getResult( _event )
					{
						this.World.getPlayerRoster().add(_event.m.Dude);
						this.World.getPlayerRoster().add(_event.m.Fisherman);
						this.World.getTemporaryRoster().clear();
						_event.m.Dude.onHired();
						_event.m.Fisherman.onHired();
						_event.m.Dude = null;
						_event.m.Fisherman = null;
						return 0;
					}

				}
			],
			function start( _event )
			{
				local roster = this.World.getTemporaryRoster();
				_event.m.Dude = roster.create("scripts/entity/tactical/player");
				_event.m.Dude.setStartValuesEx([
					"slave_background"
				]);
				_event.m.Dude.setTitle("the Sailor");
				_event.m.Dude.getBackground().m.RawDescription = "%name% travaillait sur les mers en tant que marin lorsque des pirates de la cité ont abordé son navire et l\'ont fait prisonnier avec son équipage. Par hasard, il s\'est retrouvé sous votre protection pour rembourser sa dette au Doreur.";
				_event.m.Dude.getBackground().buildDescription(true);
				_event.m.Dude.getItems().unequip(_event.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand));
				_event.m.Dude.getItems().unequip(_event.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Offhand));
				_event.m.Dude.worsenMood(2.0, "Il a été capturé par des chasseurs d\'hommes");
				this.Characters.push(_event.m.Dude.getImagePath());
				_event.m.Fisherman = roster.create("scripts/entity/tactical/player");
				_event.m.Fisherman.setStartValuesEx([
					"slave_background"
				]);
				_event.m.Fisherman.setTitle("the Mariner");
				_event.m.Fisherman.getBackground().m.Raw = "%name% travaillait sur les mers en tant que marin lorsque des pirates de la cité ont abordé son navire et l\'ont fait prisonnier avec son équipage. Par hasard, il s\'est retrouvé sous votre protection pour rembourser sa dette au Doreur.";
				_event.m.Fisherman.getBackground().buildDescription(true);
				_event.m.Fisherman.getItems().unequip(_event.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand));
				_event.m.Fisherman.getItems().unequip(_event.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Offhand));
				_event.m.Fisherman.worsenMood(2.0, "Il a été capturé par des chasseurs d\'hommes");
				this.Characters.push(_event.m.Fisherman.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "E",
			Text = "[img]gfx/ui/events/event_157.png[/img]{Le chasseur d\'hommes s\'incline brièvement. %SPEECH_ON%Que ta route soit toujours dorée, voyageur.%SPEECH_OFF%Il continue son chemin tandis que les supposés marins crient qu\'ils ne sont même pas de ces terres, qu\'ils ne savent rien de ce Doreur auquel ils sont redevables en premier lieu.}",
			Banner = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Comme la vôtre.",
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
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Desert)
		{
			return;
		}

		local currentTile = this.World.State.getPlayer().getTile();

		if (currentTile.Type != this.Const.World.TerrainType.Desert && currentTile.TacticalType != this.Const.World.TerrainTacticalType.DesertHills)
		{
			return;
		}

		if (!currentTile.HasRoad)
		{
			return;
		}

		if (this.World.Assets.getOrigin().getID() == "scenario.manhunters")
		{
			if (this.World.getPlayerRoster().getSize() >= this.World.Assets.getBrothersMax() - 1)
			{
				return;
			}
		}
		else if (this.World.getPlayerRoster().getSize() >= this.World.Assets.getBrothersMax())
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local candidates_fisherman = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.fisherman" && bro.getEthnicity() == 0)
			{
				candidates_fisherman.push(bro);
			}
		}

		if (candidates_fisherman.len() != 0)
		{
			this.m.Fisherman = candidates_fisherman[this.Math.rand(0, candidates_fisherman.len() - 1)];
		}

		this.m.Score = 5;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"fisherman",
			this.m.Fisherman != null ? this.m.Fisherman.getName() : ""
		]);
	}

	function onClear()
	{
		this.m.Fisherman = null;
		this.m.Dude = null;
	}

});

