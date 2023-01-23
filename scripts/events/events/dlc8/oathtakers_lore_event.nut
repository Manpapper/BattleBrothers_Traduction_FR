this.oathtakers_lore_event <- this.inherit("scripts/events/event", {
	m = {
		Oathtaker = null,
		Town = null,
		Replies = [],
		Results = [],
		Texts = []
	},
	function create()
	{
		this.m.ID = "event.oathtakers_lore";
		this.m.Title = "À %townname%";
		this.m.Cooldown = 99999.0 * this.World.getTime().SecondsPerDay;
		this.m.Texts.resize(4);
		this.m.Texts[0] = "Speak about Oaths.";
		this.m.Texts[1] = "Speak about Young Anselm.";
		this.m.Texts[2] = "Speak about those pieces of shite.";
		this.m.Texts[3] = "We\'ve said everything there is to say.";
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_97.png[/img]{Les habitants de la ville de %townname% sont heureux de voir la compagnie %companyname%. C\'est un accueil inhabituel pour un groupe de mercenaires, mais il semble que les aspects de votre activité liés aux serments soient tenus en haute estime par les laïcs.%SPEECH_ON%Il est temps que quelqu\'un ramène l\'honneur et la fierté sur ces terres.%SPEECH_OFF%C\'est ce qu\'un paysan dit . Les femmes vous ornent de fleurs et autres bonnes grâces. Alors que vous arrêtez le chariot, une foule d\'enfants s\'approche et veut toucher le crâne du jeune Anselme.%SPEECH_ON%Cela nous donnera-t-il de la force? Ou est-ce que ça va me rendre malade?%SPEECH_OFF%Un autre enfant arrive et lui donne un coup de coude pour l\'écarter.%SPEECH_ON%Demandez-lui de nous dire ce qu\'il fait et ce qu\'il a déjà fait! Les serments, ce crâne, et l\'autre jour nous avons entendu parler des Oathbringers, alors qu\'est-ce qui vous rend si différents?%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [],
			function start( _event )
			{
				_event.addReplies(this.Options);
			}

		});
		this.m.Screens.push({
			ID = "B0",
			Text = "[img]gfx/ui/events/event_97.png[/img]{La main sur la tête d\'Anselm, vous expliquez les Serments.%SPEECH_ON%Chaque jour où nous nous levons, nous offrons à ce monde un serment. Un serment envers nous-mêmes, envers nos proches, envers nos voisins, et même envers la terre et les animaux qui la peuplent. Nous prêtons serment au monde entier.%SPEECH_OFF%Un enfant mord dans une pomme puis il dit.%SPEECH_ON%Si tout le monde prête serment, qu\'est-ce que vous faites de plus alors? De ce fait, ne sommes-nous pas tous des Oathtakers?%SPEECH_OFF%Vous souriez et hochez la tête.%SPEECH_ON%Précisément. Nous sommes tous des Oathtakers en effet. Cependant, si je peux vous confier un petit secret...%SPEECH_OFF%Les enfants se rassemblent et se taisent. Vous expliquez.%SPEECH_ON%Quand vous êtes nés, vous ne saviez pas tout, n\'est ce pas? Comme pour nos serments. Les anciens dieux souhaitent que nous explorions le monde dans son intégralité et non que tout nous soit donné. Dans le cas contraire, serions-nous là où nous en sont aujourd\'hui? Ou serions-nous encore en train de vivre dans nos premières habitations? Nous, les Oathtakers, explorons la mesure dans laquelle les anciens dieux nous ont renforcés, mais aussi affaiblis, et en cherchant nos limites, nous deviendrons plus proches des ces dieux, et plus proches de tous les autres.%SPEECH_OFF%Un des enfants donne un coup de pied dans un monticule de terre. Il demande si vous avez des tartes sucrées dans ce chariot.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [],
			function start( _event )
			{
				_event.m.Replies[0] = true;
				_event.addReplies(this.Options);
			}

		});
		this.m.Screens.push({
			ID = "B1",
			Text = "[img]gfx/ui/events/event_97.png[/img]{Vous tapoter sur le crâne du jeune Anselme.%SPEECH_ON%Le jeune Anselme était le Premier Oathtaker, c\'était le commencement des Oathtakers. Il fut le premier à réaliser que la véritable nature de l\'homme exigeait un sacrifice. Il croyait, et à juste titre, que lorsque l\'homme a commencé à errer sur la terre, il l\'a fait dans un état de souffrance, ce qui lui a permis de faire les plus grands progrès. Ce que nous avons aujourd\'hui est tellement loin de ce que les choses étaient auparavant. Aujourd\'hui, tout est trop beau.%SPEECH_OFF%L\'un des enfants gratte une croûte noire sur son visage et la projette sur la tête d\'un autre. L\'autre enfant l\'essuie, perce une des ses pustules puis lui renvoie le pus. Pendant qu\'ils se disputent, vous continuez.%SPEECH_ON%Le jeune Anselme a compris que ce monde avait besoin de revenir à une vie de sacrifice, de renoncer à certains conforts, de s\'affûter contre la meule de la souffrance. Naturellement, cela a valu au jeune Anselme de nombreux ennemis.%SPEECH_OFF%L\'un des enfants lève les yeux et demande comment s\'est passée la mort du jeune Anselme. Vous souriez et dites que c\'est une histoire pour un autre jour.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [],
			function start( _event )
			{
				_event.m.Replies[1] = true;
				_event.addReplies(this.Options);
			}

		});
		this.m.Screens.push({
			ID = "B2",
			Text = "[img]gfx/ui/events/event_97.png[/img]{Un des enfants prend la parole.%SPEECH_ON%Nous avons eu un groupe d\'hommes comme vous en ville l\'autre jour. Ils ont dit qu\'ils étaient les  _"Oathbringers _". C\'est comme vos frères ou quoi?%SPEECH_OFF%Vous commencez à répondre quand %oathtaker% s\'interpose.%SPEECH_ON%Les Oathbringers sont des blasphémateurs! Ce sont des païens, qui ne respectent pas les serments, ils les brisent! Ils ont volé la mâchoire du jeune Anselme, et nous jurons de tuer tous les Oathbringer pour la récupérer.%SPEECH_OFF%Le garçon dit que les Oathbringers ont dit qu\'ils voulaient vous prendre le crâne, parce que vous, les Oathtakers, étiez les vrais païens.La colère de %oathtaker% atteint son point de non-retour.%SPEECH_ON%Les Oathbringers racontent beaucoup de conneries ! Ils ont les mensonges, les inepties et les crises d\'hystérie comme vitrine.%SPEECH_OFF%Vous fixez l\'Oathtaker pendant un moment, puis vous lui posez une main sur l\'épaule et lui dites qu\'il devrait peut-être aller faire l\'inventaire pour se calmer un peu.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [],
			function start( _event )
			{
				_event.m.Replies[2] = true;
				_event.addReplies(this.Options);
			}

		});
	}

	function addReplies( _to )
	{
		local n = 0;

		for( local i = 0; i < 3; i = ++i )
		{
			if (!this.m.Replies[i])
			{
				local result = this.m.Results[i];
				_to.push({
					Text = this.m.Texts[i],
					function getResult( _event )
					{
						return result;
					}

				});
				n = ++n;

				if (n >= 4)
				{
					break;
				}
			}
		}

		if (n == 0)
		{
			_to.push({
				Text = this.m.Texts[3],
				function getResult( _event )
				{
					return 0;
				}

			});
		}
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Paladins)
		{
			return;
		}

		if (this.World.Assets.getOrigin().getID() != "scenario.paladins")
		{
			return;
		}

		local towns = this.World.EntityManager.getSettlements();
		local nearTown = false;
		local town;
		local playerTile = this.World.State.getPlayer().getTile();

		foreach( t in towns )
		{
			if (t.isSouthern() || t.isMilitary())
			{
				continue;
			}

			if (t.getTile().getDistanceTo(playerTile) <= 3 && t.isAlliedWithPlayer())
			{
				nearTown = true;
				town = t;
				break;
			}
		}

		if (!nearTown)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local candidates = [];
		local haveSkull = false;

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.paladin")
			{
				candidates.push(bro);
			}

			local item = bro.getItems().getItemAtSlot(this.Const.ItemSlot.Accessory);

			if (item != null && (item.getID() == "accessory.oathtaker_skull_01" || item.getID() == "accessory.oathtaker_skull_02"))
			{
				haveSkull = true;
			}
		}

		if (!haveSkull)
		{
			local stash = this.World.Assets.getStash().getItems();

			foreach( item in stash )
			{
				if (item != null && (item.getID() == "accessory.oathtaker_skull_01" || item.getID() == "accessory.oathtaker_skull_02"))
				{
					haveSkull = true;
					break;
				}
			}
		}

		if (!haveSkull)
		{
			return;
		}

		if (candidates.len() == 0)
		{
			return;
		}

		this.m.Oathtaker = candidates[this.Math.rand(0, candidates.len() - 1)];
		this.m.Town = town;
		this.m.Score = 25;
	}

	function onPrepare()
	{
		this.m.Replies = [];
		this.m.Replies.resize(3, false);
		this.m.Results = [];
		this.m.Results.resize(3, "");

		for( local i = 0; i < 3; i = ++i )
		{
			this.m.Results[i] = "B" + i;
		}
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"oathtaker",
			this.m.Oathtaker.getName()
		]);
		_vars.push([
			"townname",
			this.m.Town.getName()
		]);
	}

	function onClear()
	{
		this.m.Oathtaker = null;
		this.m.Town = null;
	}

});

