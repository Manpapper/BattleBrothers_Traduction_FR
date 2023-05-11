this.oathtaker_joins_event <- this.inherit("scripts/events/event", {
	m = {
		Dude = null
	},
	function create()
	{
		this.m.ID = "event.oathtaker_joins";
		this.m.Title = "Sur la route...";
		this.m.Cooldown = 30.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_180.png[/img]{Un homme en armure s\'approche de la compagnie. Il semble tout à fait normal, jusqu\'à ce qu\'il ouvre la bouche.%SPEECH_ON%Oyez, oyez, je suis un fier Oathtaker! Maintenant, je vois que vous avez aussi ce qui semble être un grand respect pour faire ce qui est juste. Cela me fait croire que vous aussi, vous êtes des Oathtaker. Alors, je n\'ai qu\'une question à vous poser: ce crâne suspendu à un collier, quel est son nom? Si c\'est celui que je cherche, alors vous aurez ma main.%SPEECH_OFF% | Les hommes en armure ne sont pas rares sur les routes de nos jours, mais cet homme a un certain niveau de préstige et de théâtralité qui attire le regard, tout comme le fait qu\'il s\'avance vers vous avec assurance.%SPEECH_ON%Je faisais la fête dans un pub local quand j\'ai appris qu\'une bande de Oathtakers était de passage sur ces terres. Maintenant, soit c\'est un crâne qui vient d\'un cimetière qui pend à votre cou, soit c\'est... eh bien, à vous de me le dire. Donnez-moi le nom exact de ce crâne et je vous rejoins ici et maintenant.%SPEECH_OFF% | Vous rencontrez un homme en armure. Il se tient sur la route comme s\'il voulait se suicider à coups de sabre ou risquer sa peau pour une pièce. Lorsque vous vous approchez, il vous fait signe de descendre.%SPEECH_ON%Ah, les hommes que je cherche. Etes-vous avec les Oathtakers? Je souhaite vous rejoindre sur le chemin. Le chemin de...%SPEECH_OFF%Il fait une pause, en faisant un geste vers le crâne de la compagnie. Oh, il veut dire... | Un homme en armure se précipite sur la route. Vous portez la main à votre épée, mais il s\'incline simplement comme si vous étiez un bourreau.%SPEECH_ON%J\'ai prié les ANCIENS dieux d\'endurcir mes vertus et de me garder sur le chemin. Étranger, c\'est bien son crâne qui pend à ton cou? Si c\'est le cas, je me joindrai à vous et aux serments que vous faites en ce moment même. S\'il vous plaît, dites-moi, est-ce le crâne sans mâchoire de notre cher... notre...%SPEECH_OFF%}",
			Banner = "",
			Characters = [],
			Options = [
				{
					Text = "Jeune Anselm.",
					function getResult( _event )
					{
						return "B";
					}

				},
				{
					Text = "Hugo.",
					function getResult( _event )
					{
						return "C";
					}

				}
			],
			function start( _event )
			{
				local roster = this.World.getTemporaryRoster();
				_event.m.Dude = roster.create("scripts/entity/tactical/player");
				_event.m.Dude.setStartValuesEx([
					"paladin_background"
				]);
				local dudeItems = _event.m.Dude.getItems();

				if (dudeItems.getItemAtSlot(this.Const.ItemSlot.Head) != null && dudeItems.getItemAtSlot(this.Const.ItemSlot.Head).getID() == "armor.head.adorned_full_helm")
				{
					dudeItems.unequip(dudeItems.getItemAtSlot(this.Const.ItemSlot.Head));
					dudeItems.equip(this.new("scripts/items/helmets/adorned_closed_flat_top_with_mail"));
				}

				if (dudeItems.getItemAtSlot(this.Const.ItemSlot.Body) != null && dudeItems.getItemAtSlot(this.Const.ItemSlot.Body).getID() == "armor.body.adorned_heavy_mail_hauberk")
				{
					dudeItems.unequip(dudeItems.getItemAtSlot(this.Const.ItemSlot.Body));
					dudeItems.equip(this.new("scripts/items/armor/adorned_warriors_armor"));
				}

				this.Characters.push(_event.m.Dude.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_180.png[/img]{L\'homme tombe à genoux, la tête basse.%SPEECH_ON%En vérité, le jeune Anselm m\'a guidé jusqu\'ici! Je vous rejoindrai sur le chemin, compagnons Oathtakers!%SPEECH_OFF%}",
			Banner = "",
			Characters = [],
			Options = [
				{
					Text = "Bienvenue à bord.",
					function getResult( _event )
					{
						this.World.getPlayerRoster().add(_event.m.Dude);
						this.World.getTemporaryRoster().clear();
						_event.m.Dude.onHired();
						_event.m.Dude = null;
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Dude.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_180.png[/img]{L\'homme soupire.%SPEECH_ON%Ah, je vois maintenant. Il y a beaucoup trop de Hugos dans ce monde, cela ne me surprend pas qu\'un autre soit apparu, même si c\'est à travers de ce crâne lugubre, bien que je ne sache pas pourquoi vous le transportez ainsi.%SPEECH_OFF% | %SPEECH_ON%Hugo.%SPEECH_OFF%L\'homme dit.%SPEECH_ON%Encore un putain de Hugo, hein? Il y en a combien ici? Tous les autres hommes que je croise sont des Hugo%SPEECH_OFF%Il se retourne et s\'en va, marmonnant avec colère sur les roturiers et leurs noms peu originaux. | L\'homme soupire.%SPEECH_ON%Hugo, hein? Très bien. On se voit plus tard.%SPEECH_OFF%}",
			Banner = "",
			Characters = [],
			Options = [
				{
					Text = "Bonne chance.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Dude.getImagePath());
			}

		});
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

		if (this.World.getPlayerRoster().getSize() >= this.World.Assets.getBrothersMax())
		{
			return;
		}

		if (this.World.getTime().Days <= 30)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local numOathtakers = 0;
		local haveSkull = false;

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.paladin")
			{
				numOathtakers++;
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

		local comebackBonus = numOathtakers < 2 ? 8 : 0;
		this.m.Score = 2 + comebackBonus;
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

