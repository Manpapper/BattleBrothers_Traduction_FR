this.cannon_execution_event <- this.inherit("scripts/events/event", {
	m = {
		Dude = null
	},
	function create()
	{
		this.m.ID = "event.cannon_execution";
		this.m.Title = "Sur la route...";
		this.m.Cooldown = 99999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_177.png[/img]{Vous rencontrez un homme en tenue militaire avec deux gardes habillés de la même façon. Entre eux se trouve un homme dont les bras et les jambes sont attachés à un mortier géant, le torse tourné vers le canon, la tête reposant sur la mire. Il vous regarde avec un regard de côté.%SPEECH_ON%Ah, voyageur. Je suis dans une situation difficile. Vous voyez, ces beaux messieurs en sourdine veulent m\'éclabousser à travers les sables en utilisant la plus grande merveille technologique de notre époque. Bien que je puisse voir l\'avantage d\'éviter l\'épée rouillée du bourreau, je dois avouer que le fait que mon dernier moment soit celui où je regarde les parties de mon propre corps bombarder les créatures du désert me met dans une situation très embarrassante. Une peine juste pour certains crimes, sans doute, mais je ne suis qu\'un simple voleur.%SPEECH_OFF% Le bourreau militaire vous regarde, mais comme le voleur l\'a dit, il semble être muet. Ou peut-être sourd, comme son rôle d\'homme mortier pourrait l\'impliquer.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Quel est votre crime, exactement ?",
					function getResult( _event )
					{
						return "B";
					}

				},
				{
					Text = "Cela ne nous concerne pas.",
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
			Text = "[img]gfx/ui/events/event_177.png[/img]{Le bourreau répond de façon surprenante, se bouchant une oreille avec un doigt en parlant.%SPEECH_ON%Mercenaire, cela ne te concerne pas. Avancez.%SPEECH_OFF%Le voleur essaie à nouveau de tourner la tête.%SPEECH_ON%Ah, ah ! Il parle ! Merveilleux. Réglons ça comme de bons gentlemen avec des sensibilités en avance sur notre époque.%SPEECH_OFF%Le bourreau ignore les supplications articulées du voleur.%SPEECH_ON% Je vais faire un marché pour votre neutralité, mercenaire. Quand ce voleur sera dispersé dans le désert, tu pourras avoir ce qu\'il contient car, vois-tu, on dit qu\'il a un coeur d\'or.%SPEECH_OFF% Le voleur parle nerveusement.%SPEECH_ON%Cela veut dire autre chose d\'où je viens.%SPEECH_OFF% Tu demandes au bourreau de s\'expliquer. Il dit que le Doreur touche ceux qui s\'opposent à lui, condamnant et condamnant ceux qui sont haïs avec des entrailles en or. La condamnation est d\'un niveau supérieur à celui de la simple dette. Ça semble plutôt fantaisiste, même pour vous.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Continuez l\'exécution alors.",
					function getResult( _event )
					{
						return "C";
					}

				},
				{
					Text = "Vous devez arrêter cette exécution.",
					function getResult( _event )
					{
						return "D";
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_177.png[/img]{Tu es intéressé de voir si ce que dit le bourreau est vrai et tu te tiens à l\'écart. Le voleur soupire.%SPEECH_ON%Bien. Très bien, alors. Assure-toi juste que quand ils écrivent sur moi, cette exécution n\'est pas canon. L\'explosion désintègre l\'homme et la force pulvérisatrice projette une vague de sable hors du mortier lui-même, expulsant un nuage de poussière et de sang, tourbillonnant dans l\'air comme une tempête de viscères, et quelques instants plus tard les morceaux de corps commencent à saupoudrer le sol. Aucun de ces morceaux n\'est doré. En fait, la plupart sont noircis par le feu ou rouge vif, fraîchement exposés à la vue de tous. Le bourreau essuie la poudre de son visage. Il semble que nous avions tort. Le voleur sera dédommagé par le doreur lui-même, rare d\'être aussi chanceux.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Je suppose que c\'est ça",
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
			ID = "D",
			Text = "[img]gfx/ui/events/event_177.png[/img]{Vous informez les gardes et le bourreau que vous allez arrêter l\'exécution. Ils s\'éloignent immédiatement du mortier. Le bourreau se bouche à nouveau l\'oreille.%SPEECH_ON%Un arrêt de l\'exécution ? Ou as-tu dit de la commencer?%SPEECH_OFF% Le voleur rit nerveusement.%SPEECH_ON%Oui, mercenaire, clarifie ça pour notre ami ici.%SPEECH_OFF%L\'affaire est réglée lentement et pour que tout le monde entende. Étonnamment, les gardes sont d\'accord. Ils ne vous considèrent pas comme une intervention aléatoire, mais comme une personne envoyée par le Doreur lui-même, sinon pourquoi seriez-vous là ? Le voleur est libéré de l\'appareil et il est remis à la compagnie. Il tend la main. %SPEECH_ON%Tout ce qui est drôle mis à part, je me battrai pour vous, euh, hmmm... le %companyname%. Charmant. Mais je ne suis pas un voleur ordinaire, je suis un homme fier, un homme avec le sens du devoir, et un homme avec le sens des couronnes !%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Bienvenue dans l\'entreprise, je suppose.",
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
					Text = "On vous a sauvé la vie. Ça ne veut pas dire que vous êtes le bienvenu chez nous.",
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
				local roster = this.World.getTemporaryRoster();
				_event.m.Dude = roster.create("scripts/entity/tactical/player");
				_event.m.Dude.setStartValuesEx([
					"thief_southern_background"
				]);
				_event.m.Dude.getBackground().m.RawDescription = "Ce n\'est que grâce à votre intervention opportune que %name% a été sauvé de l\'exécution par un mortier géant. Voleur excentrique, sa dernière tentative ratée de cambriolage du palais d\'un vizir a été considérée comme une bonne raison de mettre en place une dissuasion très claire pour quiconque nourrit des projets similaires.";
				_event.m.Dude.getBackground().buildDescription(true);
				_event.m.Dude.getItems().unequip(_event.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand));
				_event.m.Dude.getItems().unequip(_event.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Offhand));
				_event.m.Dude.getItems().unequip(_event.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Head));
				_event.m.Dude.worsenMood(1.0, "Almost got executed by a technological marvel in spectacular fashion");
				this.Characters.push(_event.m.Dude.getImagePath());
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

		if (this.World.getPlayerRoster().getSize() >= this.World.Assets.getBrothersMax())
		{
			return;
		}

		this.m.Score = 5;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
	}

	function onClear()
	{
		this.m.Dude = null;
	}

});

